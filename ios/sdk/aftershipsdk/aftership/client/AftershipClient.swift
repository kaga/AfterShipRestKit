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
	
	public init?(apiKey: String, urlSession: RequestAgent = NSURLSession.sharedSession()) {
		guard apiKey.isEmpty == false else {
			return nil;
		}
		self.apiKey = apiKey;
		self.urlSession = urlSession;
	}
	
	public func performRequest(path: String, completionHandler: (result: RequestResult<Response>) -> Void) {
		let urlComponents = self.createUrlComponents(path);
		guard let url = urlComponents.URL else {
			completionHandler(result: RequestResult.Error(.MalformedRequest))
			return;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.urlSession.perform(request: request, completionHandler: completionHandler);
	}
	
	func createUrlComponents(path: String) -> NSURLComponents {
		return NSURLComponents(aftershipHost: self.apiHost, path: path, apiVersion: self.apiVersion);
	}
	
	func createUrlRequest(aftershipUrl url: NSURL, httpMethod: String) -> NSMutableURLRequest {
		return NSMutableURLRequest(aftershipUrl: url, httpMethod: httpMethod, apiKey: self.apiKey);
	}
}

public enum RequestResult<T> {
	case Success(response: T);
	case Error(RequestErrorType);
}

public enum RequestErrorType {
	case MalformedRequest;
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