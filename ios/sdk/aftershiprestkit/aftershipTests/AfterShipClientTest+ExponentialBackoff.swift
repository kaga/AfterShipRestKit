//
//  AfterShipClientTest+ExponentialBackoff.swift
//  aftership
//
//  Created by Kwun Ho Chan on 18/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class AfterShipClientTest_ExponentialBackoff: XCTestCase {
	
	func testGetNumberOfRetriesSinceServiceUnavailable() {
		let agent = MockRequestAgent();
		let client = AfterShipClient(apiKey: "AfterShipApiKey", requestAgent: agent)!;
		XCTAssertEqual(client.numberOfRetriesSinceServiceUnavailable, 0, "Should be 0 because never make a request yet");
		
		client._numberOfRetriesSinceServiceUnavailable = (10, NSDate(timeIntervalSinceNow: -61));
		XCTAssertEqual(client.numberOfRetriesSinceServiceUnavailable, 0, "Should be reset to 0 because the client has been idle for some time");
		
		client._numberOfRetriesSinceServiceUnavailable = (10, NSDate());
		XCTAssertEqual(client.numberOfRetriesSinceServiceUnavailable, 10, "Should be 10 because just made a request");
	}
	
	func testExpoentialBackoffReset() {
		let expectation = expectationWithDescription("Request to service some time later");
		
		let agent = MockRequestAgent();
		let client = AfterShipClient(apiKey: "AfterShipApiKey", requestAgent: agent)!;
		
		let testStartTime = NSDate();
		var requestDuration: NSTimeInterval = 0;
		
		let completionHandler: RequestAgentCompletionHandler = { (result) in
			AfterShipAssertSuccessResponse(result);
			requestDuration = NSDate().timeIntervalSinceDate(testStartTime);
			expectation.fulfill();
		}
		
		client._numberOfRetriesSinceServiceUnavailable = (10, NSDate(timeIntervalSinceNow: -61));
		client.performMockRequest(completionHandler);
		
		waitForExpectationsWithTimeout(3, handler: nil);
		
		XCTAssertGreaterThan(requestDuration, 0,
		                     "Should reset the backoff counter if last request was long time ago");
	}
	
	func testRetryAttemptsRecording() {
		let expectation = expectationWithDescription("Service Error");
		
		let agent = ErrorRequestAgent();
		let client = AfterShipClient(apiKey: "AfterShipApiKey", requestAgent: agent)!;
		
		XCTAssertNil(client._numberOfRetriesSinceServiceUnavailable, "Initialial state check");
		client.performMockRequest{ (result) in
			AfterShipAssertErrorReponse(result);
			XCTAssertNotNil(client._numberOfRetriesSinceServiceUnavailable);
			expectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testExponentialBackoffRetryOnServiceUnavailable() {
		let requestDuration = timePerformRequestDuration(.ServiceInternalError, numberOfRetries: 2);
		XCTAssertGreaterThan(requestDuration, 0,
		                     "Should limit the client somewhat because we don't want to ping the service to death if it is already down");
	}
	
	func testWhenServiceRunOutOfRequestLimit() {
		let requestDuration = timePerformRequestDuration(.TooManyRequests, numberOfRetries: 2);
		XCTAssertGreaterThan(requestDuration, 0, "Both 500 errors and 429 should trigger the backoff procedure");
	}
	
	func timePerformRequestDuration(errorType: RequestErrorType, numberOfRetries: Int) -> NSTimeInterval {
		let expectation = expectationWithDescription("Request to a service");
		
		let agent = ErrorRequestAgent();
		agent.errorType = errorType;
		let client = AfterShipClient(apiKey: "AfterShipApiKey", requestAgent: agent)!;
		
		let testStartTime = NSDate();
		var requestDuration: NSTimeInterval = 0;
		
		let completionHandler: RequestAgentCompletionHandler = { (result) in
			let responseErrorType = AfterShipAssertErrorReponse(result);
			XCTAssertEqual(responseErrorType, errorType);
			requestDuration = NSDate().timeIntervalSinceDate(testStartTime);
			expectation.fulfill();
		}
		
		client._numberOfRetriesSinceServiceUnavailable = (numberOfRetries, NSDate());
		client.performMockRequest(completionHandler);
		
		waitForExpectationsWithTimeout(10, handler: nil);
		return requestDuration;
	}
}
