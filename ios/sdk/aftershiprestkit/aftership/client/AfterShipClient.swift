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
	
	private let requestAgent: RequestAgent;
	private lazy var sleepTimeGenerator: ExponentialBackoff = {
		return ExponentialBackoff(baseDelayTimeInSeconds: 1, maximumDelayTimeInSeconds: 60);
	}();
	
	var _numberOfRetriesSinceServiceUnavailable: (retryAttepts: Int, lastRetry: NSDate)? = nil;
	var _rateLimit: RateLimit? = nil;
	
	/**
		Interacts with the AfterShip REST API

		- parameters:
			- apiKey: The API Key from [AfterShip](https://www.aftership.com/apps/api). Cannot be empty.
			- requestAgent: object that perform the network request. Defaults to NSURLSession.sharedSession()
	
		It manages the connections between the API endpoints and error handling logics. 
		Note that a different reqestAgent object can supplied, useful for testing or finer configuration to the 
		network request.
	*/
	public init?(apiKey: String, requestAgent: RequestAgent = NSURLSession.sharedSession()) {
		guard apiKey.isEmpty == false else {
			return nil;
		}
		self.apiKey = apiKey;
		self.requestAgent = requestAgent;
	}
	
	/**
		[Perform Request Method]
		Perform request to the API service. 
	
		- parameter
			- request: request to be made. Header fields that the API requires will be configure by the client
			(e.g. API Key )
			- completionHandler: callback for the response
	
		It will check if there is any request quota left, or TooManyRequest error will be returned.
	
		If there is a quota available but the service previously return 429 or 500 errors, a delay will be applied 
		before performing the request. The delay time will be calculated using exponential backoff with jitter.
	
		The exponential backoff effect will be reset after inactivity for some time or sevice returned successful response.
	
		- important: When extending this client to support more REST API endpoints. It is important to call this method to
			perform the network request.
	*/
	public func perform(request request: NSMutableURLRequest, completionHandler: RequestAgentCompletionHandler) {
		if let rateLimit = self.rateLimit where (rateLimit.remaining == 0) {
			completionHandler(result: RequestResult.Error(.TooManyRequests));
			return;
		}
		
		let sleepTimeInSeconds = sleepTimeGenerator.generateSleepTime(self.numberOfRetriesSinceServiceUnavailable);
		delay(sleepTimeInSeconds) {
			request.setAftershipHeaderFields(self.apiKey);
			self.requestAgent.perform(request: request) { (result, rateLimit) in
				self.updateRateLimitInfo(rateLimit);
				self.updateNumberOfRetriesCount(result);
				completionHandler(result: result);
			}
		}
	}
	
	/**
		Helper method for creating a NSURLComponents.
	
		- return
		A NSURLComponents with host and path prefilled
		
		- parameter
			- path: Path of the url component.
	
		Example generated url - https://api.aftership.com/v4/path
	
	*/
	public func createUrlComponents(path: String) -> NSURLComponents {
		return NSURLComponents(aftershipHost: self.apiHost, path: path, apiVersion: self.apiVersion);
	}
	
	/**
		Helper method for creating a NSMutableURLRequest.
		
		- return
		A NSMutableURLRequest with url, method and required header fields configured
	
	*/
	public func createUrlRequest(aftershipUrl url: NSURL, httpMethod: String) -> NSMutableURLRequest {
		let request = NSMutableURLRequest();
		request.HTTPMethod = httpMethod;
		request.URL = url;		
		return request;
	}
	
	private func updateRateLimitInfo(rateLimit: RateLimit?) {
		_rateLimit = rateLimit;
	}
	
	private func updateNumberOfRetriesCount(requestResult: RequestResult<Response>) {
		switch requestResult {
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
	
	/**
		Last known Rate Limit information
	
		- return 
			return nil if the information is expired or not avaiable
	
		The information is retrived from header fields of the last response.
	*/
	public var rateLimit: RateLimit? {
		guard let rateLimit = _rateLimit where (rateLimit.resetDate.timeIntervalSinceNow > 0) else {
			return nil;
		}
		return rateLimit;
	}
	
	/**
		Count requests that had made since the API service is unavailable.
	
		- seealso: [Perform Request Method]
	*/
	public var numberOfRetriesSinceServiceUnavailable: Int {
		guard let retryRecord = self._numberOfRetriesSinceServiceUnavailable
			where (NSDate().timeIntervalSinceDate(retryRecord.lastRetry) < self.sleepTimeGenerator.maximumDelayTimeInSeconds) else {
				return 0;
		}
		return retryRecord.retryAttepts;
	}
}