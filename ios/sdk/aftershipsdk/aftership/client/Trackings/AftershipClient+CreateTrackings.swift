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
	public func createTracking(trackingNumber trackingNumber: String, completionHandler: CreateTrackingCompletionHandler) {
		let urlComponents = NSURLComponents(aftershipHost: apiHost, path: "/trackings", apiVersion: apiVersion);
		guard let url = urlComponents.URL where (trackingNumber.isEmpty == false) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		let body: [String: AnyObject] = [
			"tracking": [
				"tracking_number": trackingNumber
			]
		]
		guard let httpBody = try? NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "POST");
		request.HTTPBody = httpBody;
		
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
}