//
//  AftershipClientTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
import Foundation
@testable import AfterShipRestKit

class AftershipClientTest: XCTestCase {
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
	
	func testInitialize() {
		XCTAssertNil(AftershipClient(apiKey: ""), "API key should not be empty string");
	}
	
	func testRequestHeaderValues() {
		let expectation = expectationWithDescription("Request to a service");
		
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
}

extension AftershipClient {
	public func performMockRequest(completionHandler: (result: RequestResult<Response>) -> Void) {
		let urlComponents = self.createUrlComponents("/foo");
		guard let url = urlComponents.URL else {
			completionHandler(result: RequestResult.Error(.MalformedRequest));
			return;
		}
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET");
		self.performRequest(request: request, completionHandler: completionHandler);
	}
}


