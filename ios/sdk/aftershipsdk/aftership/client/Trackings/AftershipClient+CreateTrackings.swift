//
//  AftershipClient+CreateTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension AftershipClient {
	
	public func createTracking(tracking model: Tracking, completionHandler: RequestAgentCompletionHandler) {
		guard let request = self.createRequest(tracking: model) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		self.performRequest(request: request, completionHandler: completionHandler);
	}
	
	public func createTracking(trackingNumber trackingNumber: String, completionHandler: RequestAgentCompletionHandler) {
		let tracking = Tracking(json: [
			"tracking_number": trackingNumber
			]);
		self.createTracking(tracking: tracking, completionHandler: completionHandler);
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