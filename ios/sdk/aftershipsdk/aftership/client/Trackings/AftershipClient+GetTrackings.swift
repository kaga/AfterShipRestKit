//
//  AftershipClient+GetTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension AftershipClient {
	public func getTracking(trackingNumber: String, slug: String, completionHandler: (result: RequestResult<Tracking>) -> Void) {
		let urlComponents = NSURLComponents(aftershipHost: apiHost, path: "/trackings/\(slug)/\(trackingNumber)", apiVersion: apiVersion);
		guard let url = urlComponents.URL where (slug.isEmpty == false && trackingNumber.isEmpty == false) else {
			//TODO: proper error code
			completionHandler(result: RequestResult.Error(NSError(domain: "Meh", code: 0, userInfo: nil)));
			return;
		}
		
		let request = NSMutableURLRequest(aftershipUrl: url, httpMethod: "GET", apiKey: apiKey);
		urlSession.performRequest(request) { (data, response, error) in
			completionHandler(result: self.onDataTaskRequestCompleted(data, response: response, error: error));
		}
	}
	
	func onDataTaskRequestCompleted(data: NSData?, response: NSURLResponse?, error: NSError?) -> RequestResult<Tracking> {
		//TODO: handle non JSON response, error handling
		guard let data = data,
			let jsonUnwrapped = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject],
			let json = jsonUnwrapped else {
				//TODO: Error message bro!
				return .Error(NSError(domain: "Meh", code: 0, userInfo: nil));
		}
		
		//TODO: parse the data object
		return .Success(response: Tracking(json: json));
		//		print("\(json)");
		
		/*let allHeaderFields = (response as? NSHTTPURLResponse)?.allHeaderFields;
		print(allHeaderFields);
		let rateLimitReset = allHeaderFields?["X-Ratelimit-Reset"]// as? Int;
		let rateLimitLimit = allHeaderFields?["X-Ratelimit-Limit"]// as? Int;
		let rateLimitRemaining = allHeaderFields?["X-Ratelimit-Remaining"]// as? Int;
		let responseTime = allHeaderFields?["X-Response-Time"] as? String;
		*/
		
		//NSDate(timeIntervalSince1970: rateLimitReset)
		//print("ResponseTime: \(responseTime), Limit:\(rateLimitLimit), Remaining:\(rateLimitRemaining), Reset:\(rateLimitReset)");
	}
}