//
//  TrackingTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 20/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class TrackingTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testInitialize() {
		XCTAssertNil(Tracking(trackingNumber: ""), "Should return nil for empty tracking number");
		let model = Tracking(trackingNumber: "123456");
		XCTAssertEqual(model!.trackingNumber, "123456");
		XCTAssertNil(model!.id, "No other value should be set");
	}
	
	func testTagCode() {
		XCTAssertEqual(Tracking(json: [ "tag": "Delivered" ]).tag, TrackingStatus.Delivered);
		let tag = Tracking(json: [ "tag": "Rubbish" ]).tag;
		XCTAssertNil(tag);
	}
    
    func testReadAndWriteValues() {
		var model = Tracking();
		model.id = "1";
		model.trackingNumber = "2";
		model.createdAt = NSDate(timeIntervalSince1970: 3);
		model.updatedAt = NSDate(timeIntervalSince1970: 4);
		model.trackingPostalCode = "5";
		model.trackingShipDate = NSDate(timeIntervalSince1970: 6);
		model.trackingAccountNumber = "7";
		model.trackingKey = "8";
		model.trackingDestinationCountry = "9";
		model.slug = "10";
		model.active = true;
		model.pushNotificationAndroidIds = ["12"];
		model.pushNotificationIosIds = ["13"];
		model.smsNotificationPhoneNumbers = ["14"];
		model.emails = ["15"];
		model.customerName = "16";
		model.deliveryTimeInDay = 17;
		model.destinationCountryIsoCode = "18";
		model.expectedDelivery = NSDate(timeIntervalSince1970: 19);
		model.orderId = "20";
		model.orderIdPath = "21"
		model.originCountryIsoCode = "22";
		model.uniqueToken = "23";
		model.shipmentPackageCount = 24;
		model.shipmentType = "25";
		model.shipmentWeight = 26
		model.shipmentWeightUnit = "27";
		model.signedBy = "28";
		model.source = "29";
		model.tag = TrackingStatus.AttemptFail;
		model.title = "30";
		model.trackedCount = 31;
		model.customFields = [
			"foo": "bar",
		]
		
		XCTAssertEqual(model.id, "1");
		XCTAssertEqual(model.trackingNumber, "2");
		XCTAssertEqual(model.createdAt, NSDate(timeIntervalSince1970: 3));
		XCTAssertEqual(model.updatedAt, NSDate(timeIntervalSince1970: 4));
		XCTAssertEqual(model.trackingPostalCode, "5");
		XCTAssertEqual(model.trackingShipDate, NSDate(timeIntervalSince1970: 6));
		XCTAssertEqual(model.trackingAccountNumber, "7");
		XCTAssertEqual(model.trackingKey, "8");
		XCTAssertEqual(model.trackingDestinationCountry, "9");
		XCTAssertEqual(model.slug, "10");
		XCTAssertEqual(model.active, true);
		XCTAssertEqual(model.pushNotificationAndroidIds!.first!, "12");
		XCTAssertEqual(model.pushNotificationIosIds!.first!, "13");
		XCTAssertEqual(model.smsNotificationPhoneNumbers!.first!, "14");
		XCTAssertEqual(model.emails!.first!, "15");
		XCTAssertEqual(model.customerName, "16");
		XCTAssertEqual(model.deliveryTimeInDay, 17);
		XCTAssertEqual(model.destinationCountryIsoCode, "18");
		XCTAssertEqual(model.expectedDelivery, NSDate(timeIntervalSince1970: 19));
		XCTAssertEqual(model.orderId, "20");
		XCTAssertEqual(model.orderIdPath, "21");
		XCTAssertEqual(model.originCountryIsoCode, "22");
		XCTAssertEqual(model.uniqueToken, "23");
		XCTAssertEqual(model.shipmentPackageCount, 24);
		XCTAssertEqual(model.shipmentType, "25");
		XCTAssertEqual(model.shipmentWeight, 26);
		XCTAssertEqual(model.shipmentWeightUnit, "27");
		XCTAssertEqual(model.signedBy, "28");
		XCTAssertEqual(model.source, "29");
		XCTAssertEqual(model.tag, TrackingStatus.AttemptFail);
		XCTAssertEqual(model.title, "30");
		XCTAssertEqual(model.trackedCount, 31);
		XCTAssertNil(model.checkpoints);
		XCTAssertEqual(model.customFields!["foo"] as? String, "bar");
    }
}
