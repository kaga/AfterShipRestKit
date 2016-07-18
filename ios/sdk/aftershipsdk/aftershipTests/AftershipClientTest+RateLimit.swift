//
//  AftershipClientTest+RateLimit.swift
//  aftership
//
//  Created by Kwun Ho Chan on 18/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class AftershipClientTest_RateLimit: XCTestCase {
	var client: AftershipClient!;
	var agent: MockRequestAgent!;
	
	override func setUp() {
		super.setUp();
		agent = MockRequestAgent();
		self.client = AftershipClient(apiKey: "AfterShipApiKey", urlSession: agent);
	}
	
	override func tearDown() {
		self.client = nil;
		super.tearDown();
	}
	
	func testNoRequestQuota() {
		let expectation = expectationWithDescription("Request to service after received a 429 error");
		
		client._rateLimit = RateLimit(resetDate: NSDate().dateByAddingTimeInterval(10), remaining: 0, limit: 600);
		XCTAssertNotNil(client.rateLimit);
		
		client.performMockRequest{ (result) in
			let errorType = AftershipAssertErrorReponse(result);
			XCTAssertEqual(errorType, RequestErrorType.TooManyRequests, "Should not make request to service when quota has ran out");
			expectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testQuotaResetDate() {
		let expectation = expectationWithDescription("Request to service after received a 429 error");
		
		client._rateLimit = RateLimit(resetDate: NSDate().dateByAddingTimeInterval(-1), remaining: 0, limit: 600);
		
		client.performMockRequest{ (result) in
			let response = AftershipAssertSuccessResponse(result);
			XCTAssertNotNil(response, "Should make request normally after the reset date");
			expectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
}
