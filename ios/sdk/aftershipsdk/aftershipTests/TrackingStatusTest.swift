//
//  TrackingStatusTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShip

class TrackingStatusTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testStatusTag() {
		let message =  "Valid tracking status raw value";
		XCTAssertEqual(TrackingStatus(rawValue: "Pending"), TrackingStatus.Pending, message);
		XCTAssertEqual(TrackingStatus(rawValue: "InfoReceived"), TrackingStatus.InfoReceived, message);
		XCTAssertEqual(TrackingStatus(rawValue: "InTransit"), TrackingStatus.InTransit, message);
		XCTAssertEqual(TrackingStatus(rawValue: "OutForDelivery"), TrackingStatus.OutForDelivery, message);
		XCTAssertEqual(TrackingStatus(rawValue: "AttemptFail"), TrackingStatus.AttemptFail, message);
		XCTAssertEqual(TrackingStatus(rawValue: "Delivered"), TrackingStatus.Delivered, message);
		XCTAssertEqual(TrackingStatus(rawValue: "Exception"), TrackingStatus.Exception, message);
		XCTAssertEqual(TrackingStatus(rawValue: "Expired"), TrackingStatus.Expired, message);
		
		XCTAssertEqual(TrackingStatus(rawValue: "Foo"), nil, "Invalid status tag should return nil");
		XCTAssertEqual(TrackingStatus(rawValue: ""), nil, "Status tag with empty should return nil");
	}

}
