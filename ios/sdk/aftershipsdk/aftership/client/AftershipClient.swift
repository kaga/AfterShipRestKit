//
//  api.swift
//  aftership
//
//  Created by Kwun Ho Chan on 14/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

//TODO rename class
public class AftershipClient {
	public var apiHost: String = "api.aftership.com";
	public let apiVersion: Int = 4;
	public let apiKey: String;
	
	private let urlSession: RequestAgent;
	
	public var rateLimit: RateLimit? {
		guard let rateLimit = _rateLimit where (rateLimit.resetDate.timeIntervalSinceNow > 0) else {
			self._rateLimit = nil;
			return nil;
		}
		return rateLimit;
	}
	
	public var numberOfRetriesSinceServiceUnavailable: Int {
		guard let retryRecord = self._numberOfRetriesSinceServiceUnavailable //else {
			where (NSDate().timeIntervalSinceDate(retryRecord.lastRetry) < self.sleepTimeGenerator.maximumDelayTimeInSeconds) else {
			return 0;
		}
		return retryRecord.retryAttepts;
	}
	
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
	
	public func performRequest(request request: NSMutableURLRequest, completionHandler: (result: RequestResult<Response>) -> Void) {
		if let rateLimit = self.rateLimit where (rateLimit.remaining == 0) {
			completionHandler(result: RequestResult.Error(.TooManyRequests));
			return;
		}
		
		let sleepTimeInSeconds = sleepTimeGenerator.generateSleepTime(self.numberOfRetriesSinceServiceUnavailable);
		delay(sleepTimeInSeconds) {
			request.setAftershipHeaderFields(self.apiKey);
			self.urlSession.perform(request: request) { (result) in
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
				completionHandler(result: result);
			}
		}
	}
	
	func createUrlComponents(path: String) -> NSURLComponents {
		return NSURLComponents(aftershipHost: self.apiHost, path: path, apiVersion: self.apiVersion);
	}
	
	func createUrlRequest(aftershipUrl url: NSURL, httpMethod: String) -> NSMutableURLRequest {
		return NSMutableURLRequest(aftershipUrl: url, httpMethod: httpMethod, apiKey: self.apiKey);
	}
}

public typealias RateLimit = (resetDate: NSDate, remaining: Int, limit: Int);

public enum RequestResult<T> {
	case Success(response: T);
	case Error(RequestErrorType);
}

public enum RequestErrorType: String {
	case MalformedRequest = "BadRequest";
	case Unauthorized = "Unauthorized";
	case Forbidden = "Forbidden";
	case NotFound = "NotFound";
	case TooManyRequests = "TooManyRequests";
	case ServiceInternalError = "InternalError";
	case InvalidJsonData;
	//TODO more refine error type
}

public protocol RequestAgent {
	func perform(request request: NSURLRequest, completionHandler: (result: RequestResult<Response>) -> Void) -> Void;
}

extension NSURLSession: RequestAgent {
	public func perform(request request: NSURLRequest, completionHandler: (result: RequestResult<Response>) -> Void) -> Void {
		let task = self.dataTaskWithRequest(request) { (data, response, error) in
			guard let response = Response(jsonData: data) else {
				completionHandler(result: .Error(.InvalidJsonData));
				return;
			}
			completionHandler(result: .Success(response: response));
		}
		task.resume();
	}
}

func delay(delayInSeconds:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delayInSeconds * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}