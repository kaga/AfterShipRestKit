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
		self.client.performRequest("/foo") { (result) in
			guard let request = self.agent.lastUrlRequest else {
				XCTFail();
				return;
			}
			
			XCTAssertEqual(request.valueForHTTPHeaderField("Content-Type"), "application/json");
			XCTAssertEqual(request.valueForHTTPHeaderField("aftership-api-key"), "AfterShipApiKey");
			
			let version = NSBundle.AftershipRestKitBundle().versionBuild;
			XCTAssertEqual(request.valueForHTTPHeaderField("aftership-user-agent"), "aftership-restkit \(version)", "Part of the requirement - Header include 'aftership-user-agent'");
		}
	}
	
}

class MockRequestAgent: RequestAgent {
	var data: NSData?;
	var lastUrlRequest: NSURLRequest?;
	
	init() {
		let url = NSBundle(forClass: self.dynamicType).URLForResource("Demo_GetTracking", withExtension: "json", subdirectory: nil);
		self.data = NSData(contentsOfURL: url!)!;
	}
	
	func perform(request request: NSURLRequest, completionHandler: (result: RequestResult<Response>) -> Void) -> Void {
		self.lastUrlRequest = request;
		guard let response = Response(jsonData: data) else {
			completionHandler(result: .Error(.InvalidJsonData));
			return;
		}
		completionHandler(result: .Success(response: response));
	}
}
