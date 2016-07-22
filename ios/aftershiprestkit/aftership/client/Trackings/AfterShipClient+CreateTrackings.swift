//
//  AfterShipClient+CreateTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension AfterShipClient {
	
	/**
	A convenient method to call createTracking
	
	- parameters:
		- trackingNumber: identifier for the tracking. This property should not be empty.
	*/
	public func createTracking(trackingNumber trackingNumber: String, completionHandler: PerformRequestCompletionHandler) {
		let tracking = Tracking(json: [
			"tracking_number": trackingNumber
			]);
		self.createTracking(tracking: tracking, completionHandler: completionHandler);
	}
	
	/**
	Create tracking results of a single tracking.
	
	- parameters:
		- tracking: Tracking info to be created.
		- completionHander: The completion handler to call with RequestResult
	
	It performs a POST /trackings request to the service.
	*/
	public func createTracking(tracking model: Tracking, completionHandler: PerformRequestCompletionHandler) {
		guard let request = self.createRequest(tracking: model) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		self.perform(request: request, completionHandler: completionHandler);
	}
	
	private func createRequest(tracking model: Tracking) -> NSMutableURLRequest? {
		let urlComponents = NSURLComponents(aftershipHost: apiHost, path: "/trackings", apiVersion: apiVersion);
		guard let url = urlComponents.URL where (model.trackingNumber?.isEmpty == false) else {
			return nil;
		}
		
		let body: [String: AnyObject] = [
			"tracking": model.json
		];
		guard let httpBody = try? NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted) else {
			return nil;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "POST");
		request.HTTPBody = httpBody;
		return request;
	}
}