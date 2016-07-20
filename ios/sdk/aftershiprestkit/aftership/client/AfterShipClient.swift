//
//  api.swift
//  aftership
//
//  Created by Kwun Ho Chan on 14/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public class AfterShipClient {
	public var apiHost: String = "api.aftership.com";
	public let apiVersion: Int = 4;
	public let apiKey: String;
	
	private let urlSession: RequestAgent;	
	private lazy var sleepTimeGenerator: ExponentialBackoff = {
		return ExponentialBackoff(baseDelayTimeInSeconds: 1, maximumDelayTimeInSeconds: 60);
	}();
	
	var _numberOfRetriesSinceServiceUnavailable: (retryAttepts: Int, lastRetry: NSDate)? = nil;
	var _rateLimit: RateLimit? = nil;
	
	public init?(apiKey: String, urlSession: RequestAgent = NSURLSession.sharedSession()) {
		guard apiKey.isEmpty == false else {
			return nil;
		}
		self.apiKey = apiKey;
		self.urlSession = urlSession;
	}
	
	public func performRequest(request request: NSMutableURLRequest, completionHandler: RequestAgentCompletionHandler) {
		if let rateLimit = self.rateLimit where (rateLimit.remaining == 0) {
			completionHandler(result: RequestResult.Error(.TooManyRequests));
			return;
		}
		
		let sleepTimeInSeconds = sleepTimeGenerator.generateSleepTime(self.numberOfRetriesSinceServiceUnavailable);
		delay(sleepTimeInSeconds) {
			request.setAftershipHeaderFields(self.apiKey);
			self.urlSession.perform(request: request) { (result) in
				self.updateRateLimitInfo(result);
				self.updateNumberOfRetriesCount(result);
				completionHandler(result: result);
			}
		}
	}
	
	public func createUrlComponents(path: String) -> NSURLComponents {
		return NSURLComponents(aftershipHost: self.apiHost, path: path, apiVersion: self.apiVersion);
	}
	
	public func createUrlRequest(aftershipUrl url: NSURL, httpMethod: String) -> NSMutableURLRequest {
		return NSMutableURLRequest(aftershipUrl: url, httpMethod: httpMethod, apiKey: self.apiKey);
	}
	
	private func updateRateLimitInfo(result: RequestResult<Response>) {
		switch result {
		case .Success(let response):
			if let rateLimit = response.rateLimit {
				_rateLimit = rateLimit;
			}
		default:
			break;
		}
	}
	
	private func updateNumberOfRetriesCount(result: RequestResult<Response>) {
		switch result {
		case .Error(let errorType) where (errorType == .TooManyRequests) || (errorType == .ServiceInternalError):
			if let retryRecord = self._numberOfRetriesSinceServiceUnavailable {
				self._numberOfRetriesSinceServiceUnavailable = (retryAttepts: retryRecord.retryAttepts + 1, lastRetry: NSDate());
			} else {
				self._numberOfRetriesSinceServiceUnavailable = (retryAttepts: 0, lastRetry: NSDate());
			}
			break;
		default:
			self._numberOfRetriesSinceServiceUnavailable = nil;
			break;
		}
	}
}

public extension AfterShipClient {
	public var rateLimit: RateLimit? {
		guard let rateLimit = _rateLimit where (rateLimit.resetDate.timeIntervalSinceNow > 0) else {
			return nil;
		}
		return rateLimit;
	}
	
	public var numberOfRetriesSinceServiceUnavailable: Int {
		guard let retryRecord = self._numberOfRetriesSinceServiceUnavailable
			where (NSDate().timeIntervalSinceDate(retryRecord.lastRetry) < self.sleepTimeGenerator.maximumDelayTimeInSeconds) else {
				return 0;
		}
		return retryRecord.retryAttepts;
	}
}