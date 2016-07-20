//
//  RequestAgent.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public protocol RequestAgent {
	func perform(request request: NSURLRequest, completionHandler: RequestAgentCompletionHandler) -> Void;
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
	//TODO more refine error type
}

public typealias RequestAgentCompletionHandler = (result: RequestResult<Response>) -> Void;

extension NSURLSession: RequestAgent {
	public func perform(request request: NSURLRequest, completionHandler: (result: RequestResult<Response>) -> Void) -> Void {
		let task = self.dataTaskWithRequest(request) { (data, response, error) in
			guard let response = response as? NSHTTPURLResponse,
				let envelope = Response(jsonData: data, rateLimit: response.rateLimit) else {
				completionHandler(result: .Error(.InvalidJsonData));
				return;
			}
			completionHandler(result: .Success(response: envelope));
		}
		task.resume();
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