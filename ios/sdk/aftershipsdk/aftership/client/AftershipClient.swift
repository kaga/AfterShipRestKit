//
//  api.swift
//  aftership
//
//  Created by Kwun Ho Chan on 14/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public class AftershipClient {
	public var apiHost: String = "api.aftership.com";
	
	public let apiVersion: Int = 4;
	public let urlSession: RequestAgent;
	public let apiKey: String;
	
	public init(apiKey: String, urlSession: RequestAgent = NSURLSession.sharedSession()) {
		self.apiKey = apiKey;
		self.urlSession = urlSession;
	}
}

public enum RequestResult<T> {
	case Success(response: T);
	case Error(NSError);
}

public protocol RequestAgent {
	func performRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> Void;
}

extension NSURLSession: RequestAgent {
	public func performRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> Void {
		let task = self.dataTaskWithRequest(request, completionHandler: completionHandler);
		task.resume();
	}
}