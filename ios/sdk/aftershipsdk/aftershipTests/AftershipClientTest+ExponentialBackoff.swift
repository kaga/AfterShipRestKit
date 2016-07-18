//
//  AftershipClientTest+ExponentialBackoff.swift
//  aftership
//
//  Created by Kwun Ho Chan on 18/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class AftershipClientTest_ExponentialBackoff: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
	
	func testExpoentialBackoffReset() {
		let expectation = expectationWithDescription("Request to service some time later");
		
		let agent = MockRequestAgent();
		let client = AftershipClient(apiKey: "AfterShipApiKey", urlSession: agent)!;
		
		let testStartTime = NSDate();
		var requestDuration: NSTimeInterval = 0;
		
		let completionHandler: (result: RequestResult<Response>) -> Void = { (result) in
			switch result {
			case .Success(_):
				requestDuration = NSDate().timeIntervalSinceDate(testStartTime);
				expectation.fulfill();
				break;
			default:
				XCTFail();
			}
		}
		
		client._numberOfRetriesSinceServiceUnavailable = 10;
		client.performRequest("/foo", completionHandler: completionHandler);
		
		waitForExpectationsWithTimeout(3, handler: nil);
		
		XCTAssertGreaterThan(requestDuration, 0,
		                     "Should reset the backoff counter if last request was long time ago");
	}
	
	func timePerformRequestDuration(errorType: RequestErrorType, numberOfRetries: Int) -> NSTimeInterval {
		let expectation = expectationWithDescription("Request to a service");
		
		let agent = ErrorRequestAgent();
		agent.errorType = errorType;
		let client = AftershipClient(apiKey: "AfterShipApiKey", urlSession: agent)!;
		
		let testStartTime = NSDate();
		var requestDuration: NSTimeInterval = 0;
		
		let completionHandler: (result: RequestResult<Response>) -> Void = { (result) in
			switch result {
			case .Error(let responseErrorType):
				XCTAssertEqual(responseErrorType, errorType);
				requestDuration = NSDate().timeIntervalSinceDate(testStartTime);
				expectation.fulfill();
				break;
			default:
				XCTFail();
			}
		}
		
		client._numberOfRetriesSinceServiceUnavailable = numberOfRetries;
		client.performRequest("/foo", completionHandler: completionHandler);
		
		waitForExpectationsWithTimeout(10, handler: nil);
		return requestDuration;
	}

}
