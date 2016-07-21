//
//  RequestAgent.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public typealias RequestAgentCompletionHandler = (result: RequestResult<Response>, rateLimit: RateLimit?) -> Void;
public protocol RequestAgent {
	func perform(request request: NSURLRequest, completionHandler: RequestAgentCompletionHandler) -> Void
}

/**
	Possible result for performing a request. 
	- important: It is recommanded to use *switch* statment without the default case to handle the control flow
*/
public enum RequestResult<T> {
	case Success(response: T);
	case Error(RequestErrorType);
}

/**
	List of possible errors that a requset might return. The error might come externally from the REST API or
	internally ( i.e. A MalformedRequest error will return immediately if a required fields is missing ).
*/
public enum RequestErrorType: String {
	case MalformedRequest = "BadRequest";
	case Unauthorized = "Unauthorized";
	case Forbidden = "Forbidden";
	case NotFound = "NotFound";
	case TooManyRequests = "TooManyRequests";
	case ServiceInternalError = "InternalError";
	case InvalidJsonData;
	case UnsupportedType;
}

extension NSURLSession: RequestAgent {
	public func perform(request request: NSURLRequest, completionHandler: RequestAgentCompletionHandler) -> Void {
		let task = self.dataTaskWithRequest(request) { (data, response, error) in
			let (result, rateLimit) = self.processResponse(data, response: response, error: error);
			completionHandler(result: result, rateLimit: rateLimit);
		}
		task.resume();
	}
	
	func processResponse(data: NSData?, response: NSURLResponse?, error: NSError?) -> (result: RequestResult<Response>, rateLimit: RateLimit?) {
		guard let response = response as? NSHTTPURLResponse else {
			return (result: .Error(.UnsupportedType), rateLimit: nil)
		}
		
		if let envelope = Response(jsonData: data) {
			if let errorType = envelope.metadata.type {
				return (result: .Error(errorType), rateLimit: response.rateLimit);
			} else {
				return (result: .Success(response: envelope), rateLimit: response.rateLimit)
			}
		} else {
			switch response.statusCode {
			case 200...299:
				return (result: .Error(.InvalidJsonData), rateLimit: response.rateLimit);
			case 400...404:
				return (result: .Error(.MalformedRequest), rateLimit: response.rateLimit);
			default:
				return (result: .Error(.ServiceInternalError), rateLimit: response.rateLimit);
			}
		}
	}
}

extension NSHTTPURLResponse {
	var rateLimit: RateLimit? {
		guard let resetString = self.allHeaderFields["X-Ratelimit-Reset"] as? String,
			let limitString = self.allHeaderFields["X-Ratelimit-Limit"] as? String,
			let remainingString = self.allHeaderFields["X-Ratelimit-Remaining"] as? String,
			let reset = NSTimeInterval(resetString),
			let limit = Int(limitString),
			let remaining = Int(remainingString) else {
				return nil;
		}
		return RateLimit(resetDate: NSDate(timeIntervalSince1970: reset), remaining: remaining, limit: limit);
	}
}