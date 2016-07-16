//
//  ResponseTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 16/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShip

class ResponseTest: XCTestCase {
	let getTrackingResponse: [String: AnyObject] = [
		"meta": [
			"code": 200
		],
		"data": [
			"tracking": [
				"id": "1234567890"
			]
		]
	];
	let getTrackingsResponse: [String: AnyObject] = [
		"meta": [
			"code": 200
		],
		"data": [
			"page": 1,
			"limit": 100,
			"count": 4,
			"keyword": "",
			"slug": "",
			"origin": [],
			"destination": [],
			"tag": "",
			"fields": "",
			"created_at_min": "2016-04-17T12:59:00+08:00",
			"created_at_max": "2016-07-16T12:59:59+08:00",
			"trackings": []
		]
	];
	
    func testValidResponseJson() {
		let response = Response(json: getTrackingResponse);
		let metadata = response?.metadata;
		let tracking = response?.tracking;
		
		XCTAssertNotNil(metadata);
		XCTAssertNotNil(tracking);
		
		XCTAssertEqual(metadata?.code, 200);
		XCTAssertEqual(tracking?.id, "1234567890");
    }
	
	func testInvalidDataModelFromResponse() {
		let response = Response(json: getTrackingsResponse);
		XCTAssertNil(response?.tracking, "Should not create a single Tracking object from GET /trackings JSON");
	}
	
	func testInvalidResponseJson() {
		let nonAftershipApiResponse = Response(json: ["foo": "bar"]);
		let invalidDataTypeResponse = Response(json: ["meta": "bar", "data": "bar"]);
		XCTAssertNil(nonAftershipApiResponse, "Return nil if meta or data property is absent");
		XCTAssertNil(invalidDataTypeResponse, "Meta and data property should be a dictionary");
	}
}
