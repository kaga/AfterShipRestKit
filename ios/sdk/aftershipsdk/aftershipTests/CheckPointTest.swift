//
//  CheckPointTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShip

class CheckPointTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testCheckPointJson() {
		let slug = "abc";
		let message = "Shipment transiting from foo to bar";
		let location = "HONG KONG";
		let tagCode = "InTransit";
		let json: [String: AnyObject] = [
			"slug": slug,
			"city": NSNull(),
			"created_at": "2016-05-04T10:37:03+00:00",
			"location": location,
			"country_name": NSNull(),
			"message": message,
			"country_iso3": NSNull(),
			"tag": tagCode,
			"checkpoint_time": "2016-05-01T20:22:30",
			"coordinates": [],
			"state": NSNull(),
			"zip": NSNull()
		];
		let checkpoint = Checkpoint(json: json)!;
		
		let validPropertiesMessage = "Valid properties should be parsed";
		XCTAssertEqual(checkpoint.slug, slug, validPropertiesMessage);
		XCTAssertEqual(checkpoint.message, message, validPropertiesMessage);
		XCTAssertEqual(checkpoint.location, location, validPropertiesMessage);
		XCTAssertEqual(checkpoint.tag, TrackingStatus.InTransit, validPropertiesMessage);
		
		XCTAssertEqual(compareDate(checkpoint.createdAt!, expectedDateComponents: (2016, 5, 4, 10, 37, 3)), NSComparisonResult.OrderedSame);
		XCTAssertEqual(compareDate(checkpoint.checkPointTime!, expectedDateComponents: (2016, 5, 1, 20, 22, 30)), NSComparisonResult.OrderedSame);
		
		XCTAssertNil(checkpoint.city, "Expect properties are nil");
		XCTAssertNil(checkpoint.countryName);
		XCTAssertNil(checkpoint.countryIsoCode);
		XCTAssertNil(checkpoint.state);
		XCTAssertNil(checkpoint.zip);
	}
	
	func testInvalidCheckPointJson() {
		let slug = "abc";
		let message = "Shipment transiting from foo to bar";
		let location = "HONG KONG";
		let tagCode = "FooBar";
		let json: [String: AnyObject] = [
			"slug": slug,
			"city": NSNull(),
			"created_at": "",
			"location": location,
			"country_name": NSNull(),
			"message": message,
			"country_iso3": NSNull(),
			"tag": tagCode,
			"checkpoint_time": "",
			"coordinates": [],
			"state": NSNull(),
			"zip": NSNull()
		];
		let checkpoint = Checkpoint(json: json)!;
		XCTAssertNil(checkpoint.tag, "Should not crash when there is a new tag avaiable from the service");
		XCTAssertNil(checkpoint.createdAt);
		XCTAssertNil(checkpoint.checkPointTime);		
	}
}
