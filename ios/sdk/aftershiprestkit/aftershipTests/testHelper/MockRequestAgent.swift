//
//  MockRequestAgent.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation
@testable import AfterShipRestKit

class MockRequestAgent: RequestAgent {
	var data: NSData?;
	var lastUrlRequest: NSURLRequest?;
	
	init(fileName: String = "Demo_GetTracking") {
		let url = NSBundle(forClass: self.dynamicType).URLForResource(fileName, withExtension: "json", subdirectory: nil);
		self.data = NSData(contentsOfURL: url!)!;
	}
	
	func perform(request request: NSURLRequest, completionHandler: RequestAgentCompletionHandler) -> Void {
		self.lastUrlRequest = request;
	
		guard let response = Response(jsonData: data, rateLimit: RateLimit(resetDate: NSDate(timeIntervalSinceNow: 60), remaining: 599, limit: 600)) else {
			completionHandler(result: .Error(.InvalidJsonData));
			return;
		}
		completionHandler(result: .Success(response: response));
	}
}