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
		let urlComponents = self.createUrlComponents("/trackings/\(slug)/\(trackingNumber)");
		guard let url = urlComponents.URL where (slug.isEmpty == false && trackingNumber.isEmpty == false) else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.performRequest(request: request) { (result) in
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
}

