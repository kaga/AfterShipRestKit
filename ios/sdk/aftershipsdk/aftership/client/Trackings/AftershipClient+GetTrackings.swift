//
//  AftershipClient+GetTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public extension AftershipClient {
	
	public func getTracking(trackingNumber trackingNumber: String,
	                                       slug: String,
	                                       completionHandler: GetTrackingCompletionHandler) {
		guard let parameters = GetTrackingRequestParameters(slug: slug, trackingNumber: trackingNumber) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		self.getTracking(parameters: parameters, completionHandler: completionHandler);
	}
	
	public func getTracking(parameters parameters: GetTrackingRequestParameters,
										completionHandler: GetTrackingCompletionHandler) {
		guard let url = getTrackingUrl(parameters) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.performRequest(request: request) { (result) in
			switch result {
			case .Success(let response):
				guard let tracking = response.tracking else {
					completionHandler(result: .Error(.InvalidJsonData));
					break;
				}
				completionHandler(result: .Success(response: tracking));
			case .Error(let errorType):
				completionHandler(result: .Error(errorType));
			}
		}
	}
	
	private func getTrackingUrl(parameters: GetTrackingRequestParameters) -> NSURL? {
		let urlComponents = self.createUrlComponents(parameters.path);
		var queryItems = [NSURLQueryItem]();
		if let fieldsToResponse = parameters.fields {
			let value = fieldsToResponse.joinWithSeparator(",");
			let fields = NSURLQueryItem(name: "fields", value: value);
			queryItems.append(fields);
		}
		
		if let language = parameters.responseLanguage {
			queryItems.append(NSURLQueryItem(name: "lang", value: language));
		}
		urlComponents.queryItems = queryItems;		
		return urlComponents.URL;
	}
}

public struct GetTrackingRequestParameters {
	public let path: String;
	public var fields: [String]? = nil;
	public var responseLanguage: String? = nil;
	
	public init?(slug: String, trackingNumber: String) {
		guard (slug.isEmpty == false && trackingNumber.isEmpty == false) else {
			return nil;
		}
		self.path = "/trackings/\(slug)/\(trackingNumber)";
	}
	
	public init?(aftershipId identifier: String) {
		guard (identifier.isEmpty == false) else {
			return nil;
		}
		self.path = "/trackings/\(identifier)";
	}
}

public typealias GetTrackingCompletionHandler = (result: RequestResult<Tracking>) -> Void
