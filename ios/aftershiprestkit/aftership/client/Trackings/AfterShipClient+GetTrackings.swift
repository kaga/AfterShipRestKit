//
//  AfterShipClient+GetTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public extension AfterShipClient {
	/**
	A convenient method to call getTracking.
	
	- parameters:
		- trackingNumber: identifier for the tracking. This cannot be empty
		- slug: Unique for the [courier](https://www.aftership.com/docs/api/4/couriers)
		- completionHander: The completion handler to call with RequestResult
	*/
	public func getTracking(slug slug: String,
	                             trackingNumber: String,
	                             completionHandler: PerformRequestCompletionHandler) {
		guard let parameters = GetTrackingRequestParameters(slug: slug, trackingNumber: trackingNumber) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		self.getTracking(parameters: parameters, completionHandler: completionHandler);
	}
	
	/**
	Get tracking results of a single tracking.
	
	- parameters:
		- parameters: An object that contains all the required and optional parameters
		- completionHander: The completion handler to call with RequestResult
	
	It performs a GET /trackings/:slug/:trackingNumber request to the service
	*/
	public func getTracking(parameters parameters: GetTrackingRequestParameters,
	                                   completionHandler: PerformRequestCompletionHandler) {
		guard let url = getTrackingUrl(parameters) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.perform(request: request, completionHandler: completionHandler);
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

/**
The GetTrackingRequestParameters stores configuration for looking up a single tracking.
- note: you can modify the properties after initialization for advanced usage (i.e. TrackingField missing a property )
*/
public struct GetTrackingRequestParameters {
	public let path: String;
	public var fields: [String]?;
	public var responseLanguage: String? = nil;
	
	/**
	[courier]:(https://www.aftership.com/docs/api/4/couriers)
	
	Initializes a request parameter object with path set to [/trackings/:slug/:trackingNumber](https://www.aftership.com/docs/api/4/trackings/get-trackings-slug-tracking_number)
	
	- parameters:
		- trackingNumber: identifier for the tracking. This cannot be empty
		- slug: Unique for the [courier]. This cannot be empty
		- fields: Fields to include in the response
	*/
	public init?(slug: String, trackingNumber: String, fieldsToResponse fields: [TrackingField]? = nil) {
		guard (slug.isEmpty == false && trackingNumber.isEmpty == false) else {
			return nil;
		}
		self.init(path: "/trackings/\(slug)/\(trackingNumber)", fields: fields);
	}
	
	/**
	Initializes a request parameter object with path set to [/trackings/:id]([/trackings/:slug/:trackingNumber](https://www.aftership.com/docs/api/4/trackings/get-trackings-slug-tracking_number))
	
	- parameters:
		- aftershipId: A unique identifier generated by AfterShip for the tracking.
		- fields: Fields to include in the response
	*/
	public init?(aftershipId identifier: String, fieldsToResponse fields: [TrackingField]? = nil) {
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