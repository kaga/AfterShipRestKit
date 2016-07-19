//
//  AftershipClient+CreateTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public typealias CreateTrackingCompletionHandler = GetTrackingCompletionHandler;
extension AftershipClient {
	
	public func createTracking(tracking model: Tracking, completionHandler: CreateTrackingCompletionHandler) {
		guard let request = self.createRequest(tracking: model) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
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
	
	public func createTracking(trackingNumber trackingNumber: String, completionHandler: CreateTrackingCompletionHandler) {
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