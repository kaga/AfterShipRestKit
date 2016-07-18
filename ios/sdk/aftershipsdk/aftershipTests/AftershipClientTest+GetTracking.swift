//
//  AftershipClientTest+GetTracking.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
import AfterShipRestKit

class AftershipClientTest_GetTracking: XCTestCase {
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
		
		self.client.getTracking(trackingNumber: "123456", slug: "Foo") { (result) in
			let response = AftershipAssertSuccessResponse(result);
			XCTAssertNotNil(response);
			
			XCTAssertEqual(response.id, "A1B2C3D4", "Make sure the Tracking model is not garbage");
			self.compareDate(response.createdAt!, expectedDateComponents: (2016, 7, 16, 14, 2, 13));
			self.compareDate(response.updatedAt!, expectedDateComponents: (2016, 7, 16, 14, 2, 17));
			//				self.compareDate(response.lastUpdatedAt!, expectedDateComponents: (2016, 7, 16, 14, 2, 17));
			//				XCTAssertEqual(response.trackingNumber, "012345678901");
			XCTAssertEqual(response.slug, "express");
			XCTAssertEqual(response.active, false);
			XCTAssertNil(response.pushNotificationAndroidIds, "Empty array should return nil");
			XCTAssertNil(response.customFields);
			XCTAssertNil(response.customerName);
			XCTAssertEqual(response.deliveryTimeInDay, 6);
			XCTAssertNil(response.destinationCountryIsoCode);
			
			XCTAssertEqual(response.emails?.count, 1, "one email notification entry");
			let email = (response.emails?.first)!;
			XCTAssertEqual(email, "foo@bar.com");
			
			XCTAssertEqual(response.expectedDelivery, nil);
			XCTAssertNil(response.pushNotificationIosIds, "Empty array should return nil");
			//				XCTAssertEqual(response.note, nil);
			XCTAssertEqual(response.orderId, "");
			XCTAssertEqual(response.orderIdPath, "");
			XCTAssertEqual(response.shipmentPackageCount, 1);
			//				self.compareDate(response.shipmentPickupDate!, expectedDateComponents: (2016, 7, 16, 12, 39, 49));
			//				self.compareDate(response.shipmentDeliveryDate!, expectedDateComponents: (2016, 7, 16, 12, 39, 49));
			XCTAssertNil(response.shipmentType);
			XCTAssertNil(response.shipmentWeight);
			XCTAssertNil(response.shipmentWeightUnit);
			XCTAssertNil(response.signedBy);
			XCTAssertNil(response.smsNotificationPhoneNumbers, "Empty array should return nil");
			XCTAssertEqual(response.source, "api");
			XCTAssertEqual(response.tag, TrackingStatus.Delivered);
			XCTAssertEqual(response.title, "012345678901");
			XCTAssertEqual(response.trackedCount, 1);
			XCTAssertEqual(response.uniqueToken, "deprecated");
			XCTAssertEqual(response.checkpoints?.count, 1, "Should have exactly 1 object");
			
			let checkpoint: Checkpoint = (response.checkpoints?.first)!;
			XCTAssertEqual(checkpoint.slug, "express");
			XCTAssertEqual(checkpoint.city, "HONG KONG");
			self.compareDate(checkpoint.createdAt!, expectedDateComponents: (2016, 7, 16, 14, 02, 17));
			XCTAssertEqual(checkpoint.location, "HONG KONG");
			XCTAssertEqual(checkpoint.countryName, nil);
			XCTAssertEqual(checkpoint.message, "Foo has picked up the shipment");
			XCTAssertEqual(checkpoint.countryIsoCode, nil);
			XCTAssertEqual(checkpoint.tag, TrackingStatus.InTransit);
			self.compareDate(checkpoint.checkPointTime!, expectedDateComponents: (2016, 7, 16, 12, 39, 49));
			XCTAssertEqual(checkpoint.state, nil);
			XCTAssertEqual(checkpoint.zip, nil);
			requestExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
	}
	
	func testGetTrackingWithEmptyTrackingNumber() {
		let emptyTrackingNumberExpectation = expectationWithDescription("Get Tracking with empty tracking number");
		self.client.getTracking(trackingNumber: "", slug: "Foo") { (result) in
			let error = AftershipAssertErrorReponse(result);
			XCTAssertNotNil(error);
			emptyTrackingNumberExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
		
		let emptySlugExpectation = expectationWithDescription("Get Tracking with empty slug");
		self.client.getTracking(trackingNumber: "123456", slug: "") { (result) in
			let error = AftershipAssertErrorReponse(result);
			XCTAssertEqual(error, RequestErrorType.MalformedRequest);
			emptySlugExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
	}
	
	func testGetTrackingNonJsonResponse() {
		agent.data = "String response".dataUsingEncoding(NSUTF8StringEncoding);
		
		let requestExpectation = expectationWithDescription("Get Tracking with non-json response");
		
		client.getTracking(trackingNumber: "123456", slug: "Foo") { (result) in
			let error = AftershipAssertErrorReponse(result);
			XCTAssertEqual(error, RequestErrorType.InvalidJsonData);
			requestExpectation.fulfill();
		}
		
		waitForExpectationsWithTimeout(1, handler: nil);
	}
	
	func testReponseOfDifferentObject() {
		let requestExpectation = expectationWithDescription("Get /tracking/slug/identifier");
		let getTrackingsJson: [String: AnyObject] = [
			"meta": [
				"code": 200
			],
			"data": [
				"page": 1,
				"limit": 100,
				"count": 4
			]
		];
		agent.data = try! NSJSONSerialization.dataWithJSONObject(getTrackingsJson, options: .PrettyPrinted);
		client.getTracking(trackingNumber: "123456", slug: "Foo") { (result) in
			let error = AftershipAssertErrorReponse(result);
			XCTAssertEqual(error, RequestErrorType.InvalidJsonData, "Should not handle GET /trackings response");
			requestExpectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}	
}
