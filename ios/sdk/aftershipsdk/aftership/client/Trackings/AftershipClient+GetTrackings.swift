//
//  AftershipClient+GetTrackings.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation


//public struct GetTrackingRequestParameters {
//	public let path: String;
//	public var fields: [String]? = nil;
//	public var responseLanguage: String? = nil;
//	
//	public init?(slug: String, trackingNumber: String) {
//		self.path = "";
//	}
//}

public typealias GetTrackingCompletionHandler = (result: RequestResult<Tracking>) -> Void

public extension AftershipClient {
//	public func getTracking(parameters parameters: GetTrackingRequestParameters,
//										completionHandler: (result: RequestResult<Tracking>) -> Void) {
//		
//		
//	}
	
	public func getTracking(trackingNumber trackingNumber: String,
	                                       slug: String,
	                                       completionHandler: (result: RequestResult<Tracking>) -> Void) {
		guard (slug.isEmpty == false && trackingNumber.isEmpty == false) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		self.performRequest("/trackings/\(slug)/\(trackingNumber)") { (result) in
			switch result {
			case .Success(let response):
				guard let tracking = response.tracking else {
					completionHandler(result: .Error(.InvalidJsonData)); //TODO Test when get trackings result returned
					break;
				}
				completionHandler(result: .Success(response: tracking));
			case .Error(let errorType):
				completionHandler(result: .Error(errorType));
			}
		}
	}
	
//	private func onDataTaskRequestCompleted(data: NSData?, response: NSURLResponse?, error: NSError?) -> RequestResult<Tracking> {
//		guard let data = data,
//			let jsonUnwrapped = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject],
//			let json = jsonUnwrapped,
//			let response = Response(json: json),
//			let tracking = response.tracking else {
//				return .Error(.InvalidJsonData);
//		}
//		return .Success(response: tracking);
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
//	}
}

