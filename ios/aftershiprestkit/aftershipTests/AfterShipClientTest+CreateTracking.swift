//
//  AfterShipClientTest+CreateTracking.swift
//  aftership
//
//  Created by Kwun Ho Chan on 18/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class AfterShipClientTest_CreateTracking: XCTestCase {
	var client: AfterShipClient!;
	var agent: MockRequestAgent!;
	
	override func setUp() {
		super.setUp();
		agent = MockRequestAgent(fileName: "Demo_CreateTracking_Response_Body");
		self.client = AfterShipClient(apiKey: "AfterShipApiKey", requestAgent: agent);
	}
	
	override func tearDown() {
		self.client = nil;
		super.tearDown();
	}
	
    func testCreateTracking() {
		let expectation = expectationWithDescription("Create Tracking Request");
		
		client.createTracking(trackingNumber: "123456789") { (result) in
			let response = AfterShipAssertSuccessResponse(result).tracking!;
			let request = self.agent.lastUrlRequest!;
			XCTAssertEqual(request.HTTPMethod, "POST");
			XCTAssertEqual(response.id, "53aa7b5c415a670000000021");
			expectation.fulfill();
		}
	
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testNoRequestQuotaOnCreateTracking() {
		let expectation = expectationWithDescription("Create Tracking Request");
		client._rateLimit = RateLimit(resetDate: NSDate().dateByAddingTimeInterval(10), remaining: 0, limit: 600);
		client.createTracking(trackingNumber: "123456789") { (result) in
			let errorType = AfterShipAssertErrorReponse(result);
			XCTAssertEqual(errorType, RequestErrorType.TooManyRequests,
			               "Should not make request to service when quota has ran out");
			expectation.fulfill();
		}
		
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testEmptyTrackingNumberToCreate() {
		let expectation = expectationWithDescription("Create Tracking Request");
		
		client.createTracking(trackingNumber: "") { (result) in
			let errorType = AfterShipAssertErrorReponse(result);
			XCTAssertEqual(errorType, RequestErrorType.MalformedRequest,
			               "Should have a non-empty tracking number to create");
			expectation.fulfill();
		}
		
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testReponseOfDifferentObject() {
		let requestExpectation = expectationWithDescription("Create Tracking Request");
		let getTrackingsJson: [String: AnyObject] = [
			"meta": [
				"code": 200
			],
			"data": [
				"page": 1,
				"limit": 100,
				"count": 4
			]
		];
		agent.data = try! NSJSONSerialization.dataWithJSONObject(getTrackingsJson, options: .PrettyPrinted);
		client.createTracking(trackingNumber: "12345", completionHandler: { (result) in
			let response = AfterShipAssertSuccessResponse(result).tracking;
			XCTAssertNil(response, "Can't make sense of the response, may be the developer will");
			requestExpectation.fulfill();
		})
		waitForExpectationsWithTimeout(3, handler: nil);
	}
}