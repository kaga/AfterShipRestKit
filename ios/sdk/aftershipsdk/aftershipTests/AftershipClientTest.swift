//
//  AftershipClientTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
import AfterShip

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

    func testGetTrackingBySlugAndTrackingNumber() {
		let requestExpectation = expectationWithDescription("Get Tracking with number and slug");
		
		self.client.getTracking("123456", slug: "Foo") { (result) in
			switch result {
			case .Success(let response):
				XCTAssertNotNil(response);
			default:
				XCTFail();
			}
			requestExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
    }
	
	func testGetTrackingWithEmptyTrackingNumber() {
		let emptyTrackingNumberExpectation = expectationWithDescription("Get Tracking with empty tracking number");
		self.client.getTracking("", slug: "Foo") { (result) in
			switch result {
			case .Error(let error):
				XCTAssertNotNil(error);
			default:
				XCTFail();
			}
			emptyTrackingNumberExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
		
		let emptySlugExpectation = expectationWithDescription("Get Tracking with empty slug");
		self.client.getTracking("123456", slug: "") { (result) in
			switch result {
			case .Error(let error):
				XCTAssertNotNil(error);
			default:
				XCTFail();
			}
			emptySlugExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
	}
	
	func testGetTrackingNonJsonResponse() {
		agent.response = "String response";
		
		let requestExpectation = expectationWithDescription("Get Tracking with non-json response");
		
		self.client.getTracking("123456", slug: "Foo") { (result) in
			switch result {
			case .Error(let error):
				XCTAssertNotNil(error);
			default:
				XCTFail();
			}
			requestExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
	}
}

class MockRequestAgent: RequestAgent {
	var response: AnyObject = [
		"meta": [
			"code":200
		],
		"data":[
			"tracking":[
				"id":"A1B2C3D4"
			]
		]
	];
	
	func performRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> Void {
		switch response {
		case let jsonResponse as [String: AnyObject]:
			let data = try! NSJSONSerialization.dataWithJSONObject(jsonResponse, options: .PrettyPrinted);
			completionHandler(data, nil, nil);
		case let stringResponse as String:
			let data = stringResponse.dataUsingEncoding(NSUTF8StringEncoding);
			completionHandler(data, nil, nil);
		default:
			completionHandler(nil, nil, nil);
		}
		
	}
}
