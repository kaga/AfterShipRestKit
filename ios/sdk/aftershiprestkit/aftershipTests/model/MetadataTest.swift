//
//  MetadataTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class MetadataTest: XCTestCase {

    func testSuccessCode() {
		let metadata = Metadata(json: [
				"code": 200
			]);
		XCTAssertNotNil(metadata);
		XCTAssertEqual(metadata.code, 200);
    }

	func testErrorCode() {
		let metadata = Metadata(json: [
			"code": 401,
			"message": "Invalid API Key.",
			"type": "Unauthorized"
			]);
		XCTAssertEqual(metadata.code, 401);
		XCTAssertEqual(metadata.message, "Invalid API Key.");
		XCTAssertEqual(metadata.type, RequestErrorType.Unauthorized);
	}
	
	func testInvalidJson() {
		let metadata = Metadata(json: [
			"code": 401,
			"message": "Invalid API Key.",
			"type": "Foo"
			]);
		XCTAssertNil(metadata.type, "Should return MetadataType rawvalue as nil");
	}

}
