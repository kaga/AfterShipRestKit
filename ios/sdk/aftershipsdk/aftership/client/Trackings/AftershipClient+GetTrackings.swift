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
	                                       completionHandler: RequestAgentCompletionHandler) {
		guard let parameters = GetTrackingRequestParameters(slug: slug, trackingNumber: trackingNumber, fields: nil) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		self.getTracking(parameters: parameters, completionHandler: completionHandler);
	}
	
	public func getTracking(parameters parameters: GetTrackingRequestParameters,
										completionHandler: RequestAgentCompletionHandler) {
		guard let url = getTrackingUrl(parameters) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.performRequest(request: request, completionHandler: completionHandler);
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
	public var fields: [String]?;
	public var responseLanguage: String? = nil;
	
	public init?(slug: String, trackingNumber: String, fields: [TrackingField]?) {
		guard (slug.isEmpty == false && trackingNumber.isEmpty == false) else {
			return nil;
		}
		self.init(path: "/trackings/\(slug)/\(trackingNumber)", fields: fields);
	}
	
	public init?(aftershipId identifier: String, fields: [TrackingField]?) {
		guard (identifier.isEmpty == false) else {
			return nil;
		}	
		self.init(path: "/trackings/\(identifier)", fields: fields);
	}
	
	init(path: String, fields: [TrackingField]?) {
		self.path = path;
		self.fields = fields?.map({ $0.key });
	}
}