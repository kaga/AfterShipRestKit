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
		var model = Tracking(json: [
			"id":"1",
			"created_at":NSDate(timeIntervalSince1970: 3).isoString,
			"updated_at":NSDate(timeIntervalSince1970: 4).isoString,
			"active":true,
			"delivery_time":17,
			"expected_delivery":NSDate(timeIntervalSince1970: 19).isoString,
			"origin_country_iso3":"22",
			"unique_token":"23",
			"shipment_package_count":24,
			"shipment_type":"25",
			"shipment_weight":26,
			"shipment_weight_unit":"27",
			"signed_by":"28",
			"source":"29",
			"tag":TrackingStatus.AttemptFail.rawValue,
			"tracked_count": 31
			]);
		
		model.trackingNumber = "2";
		model.trackingPostalCode = "5";
		model.trackingShipDate = NSDate(timeIntervalSince1970: 6);
		model.trackingAccountNumber = "7";
		model.trackingKey = "8";
		model.trackingDestinationCountry = "9";
		model.slug = "10";
		model.pushNotificationAndroidIds = ["12"];
		model.pushNotificationIosIds = ["13"];
		model.smsNotificationPhoneNumbers = ["14"];
		model.emailNotification = ["15"];
		model.customerName = "16";
		model.destinationCountryIsoCode = "18";
		model.orderId = "20";
		model.orderIdPath = "21"
		model.title = "30";
		model.customFields = [
			"foo": "bar",
		]
		
		XCTAssertEqual(model.id, "1");
		XCTAssertEqual(model.trackingNumber, "2");
		XCTAssertEqual(model.createdAt, NSDate(timeIntervalSince1970: 3));
		XCTAssertEqual(model.updatedAt, NSDate(timeIntervalSince1970: 4));
		XCTAssertEqual(model.trackingPostalCode, "5");
		XCTAssertEqual(model.trackingShipDate, NSDate(timeIntervalSince1970: 0), "It stored in YYYYMMDD format therefore the second information is lost");
		XCTAssertEqual(model.trackingAccountNumber, "7");
		XCTAssertEqual(model.trackingKey, "8");
		XCTAssertEqual(model.trackingDestinationCountry, "9");
		XCTAssertEqual(model.slug, "10");
		XCTAssertEqual(model.isActive, true);
		XCTAssertEqual(model.pushNotificationAndroidIds!.first!, "12");
		XCTAssertEqual(model.pushNotificationIosIds!.first!, "13");
		XCTAssertEqual(model.smsNotificationPhoneNumbers!.first!, "14");
		XCTAssertEqual(model.emailNotification!.first!, "15");
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
		
		let (type, weight, unit, packageCount) = model.shipment!;
		XCTAssertEqual(packageCount, 24);
		XCTAssertEqual(type, "25");
		XCTAssertEqual(weight, 26);
		XCTAssertEqual(unit, "27");
	}
	
	func testTrackingShipDate() {
		var model = Tracking();
		XCTAssertNil(model.trackingShipDate);
		
		model.trackingShipDate = NSDate(timeIntervalSince1970: 0);
		
		let trackingShipDateString = model.json[TrackingField.TrackingShipDate.rawValue] as? String;
		XCTAssertEqual(trackingShipDateString, "19700101", "Expected to be YYYYMMDD format");				
	}
}

extension NSDate {
	var isoString: String {
		let dateFormatter = NSDateFormatter();
		dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX");
		dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT");
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
		return dateFormatter.stringFromDate(self);
	}
}
