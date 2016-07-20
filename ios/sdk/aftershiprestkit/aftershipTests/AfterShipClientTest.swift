//
//  AfterShipClientTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
import Foundation
@testable import AfterShipRestKit

class AfterShipClientTest: XCTestCase {
	var client: AfterShipClient!;
	var agent: MockRequestAgent!;
	
	override func setUp() {
		super.setUp();
		agent = MockRequestAgent();
		self.client = AfterShipClient(apiKey: "AfterShipApiKey", urlSession: agent);
	}
	
	override func tearDown() {
		self.client = nil;
		super.tearDown();
	}
	
	func testInitialize() {
		XCTAssertNil(AfterShipClient(apiKey: ""), "API key should not be empty string");
	}
	
	func testRequestHeaderValues() {
		let expectation = expectationWithDescription("Request to AfterShip api");
		
		client.performMockRequest{ (result) in
			guard let request = self.agent.lastUrlRequest else {
				XCTFail();
				return;
			}
			
			XCTAssertEqual(request.valueForHTTPHeaderField("Content-Type"), "application/json");
			XCTAssertEqual(request.valueForHTTPHeaderField("aftership-api-key"), "AfterShipApiKey");
			
			let version = NSBundle.AftershipRestKitBundle().versionBuild;
			XCTAssertEqual(request.valueForHTTPHeaderField("aftership-user-agent"), "aftership-restkit \(version)",
			               "Part of the requirement - Header include 'aftership-user-agent'");
			expectation.fulfill();
		}
		
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testResetSleepTimeOnSuccessfull() {
		let expectation = expectationWithDescription("Request to a service");
	
		client._numberOfRetriesSinceServiceUnavailable = (2, NSDate());
		client.performMockRequest{ (result) in
			XCTAssertEqual(self.client.numberOfRetriesSinceServiceUnavailable, 0, "should reset the counter on received success response");
			expectation.fulfill();
		}
		waitForExpectationsWithTimeout(10, handler: nil);
	}
	
	func testRateLimitInfo() {
		let expectation = expectationWithDescription("Request to AfterShip api");
		
		XCTAssertNil(client.rateLimit, "Check initial state");
		client.performMockRequest { (result) in
			XCTAssertNotNil(self.client.rateLimit, "Expect the api should return this information and update the internal state");
			expectation.fulfill();
		}
		
		waitForExpectationsWithTimeout(10, handler: nil);
	}

	func testHttpUrlResponse() {
		let url = NSURL(string: "https://api.aftership.com/v4/trackings")!;
		let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: [
			"X-Ratelimit-Limit": "600",
			"X-Ratelimit-Remaining": "599",
			"X-Ratelimit-Reset": "1468828597",
			"X-Response-Time": "52.060ms"
			]);
		let rateLimit = response?.rateLimit;
		XCTAssertNotNil(rateLimit);
		XCTAssertEqual(rateLimit?.limit, 600);
		XCTAssertEqual(rateLimit?.remaining, 599);
		XCTAssertEqual(rateLimit?.resetDate.timeIntervalSince1970, 1468828597);
		
		let noRateLimitResponse = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil);
		XCTAssertNil(noRateLimitResponse?.rateLimit);
	}
}

extension AfterShipClient {
	public func performMockRequest(completionHandler: RequestAgentCompletionHandler) {
		let urlComponents = self.createUrlComponents("/foo");
		guard let url = urlComponents.URL else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.performRequest(request: request, completionHandler: completionHandler);
	}
}


