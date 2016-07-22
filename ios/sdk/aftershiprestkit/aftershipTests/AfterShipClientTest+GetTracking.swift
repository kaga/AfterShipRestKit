//
//  AfterShipClientTest+GetTracking.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
import AfterShipRestKit

class AfterShipClientTest_GetTracking: XCTestCase {
	var client: AfterShipClient!;
	var agent: MockRequestAgent!;
	
	override func setUp() {
		super.setUp();
		agent = MockRequestAgent();
		self.client = AfterShipClient(apiKey: "AfterShipApiKey", requestAgent: agent);
	}
	
	override func tearDown() {
		self.client = nil;
		super.tearDown();
	}
	
	func testGetTrackingRequestParameters() {
		XCTAssertNil(GetTrackingRequestParameters(slug: "", trackingNumber: "", fields: nil), "Slug and tracking number can't be empty");
		
		let parameters = GetTrackingRequestParameters(slug: "ABC", trackingNumber: "123456", fields: [.AftershipId]);
		XCTAssertNotNil(parameters);
		XCTAssertEqual(parameters?.path, "/trackings/ABC/123456");
		XCTAssertTrue(parameters!.fields!.contains(TrackingField.AftershipId.rawValue));

		XCTAssertNil(GetTrackingRequestParameters(aftershipId: "", fields: nil), "Aftership id can't be empty");
		let getByIdParameters = GetTrackingRequestParameters(aftershipId: "123456", fields: nil);
		XCTAssertEqual(getByIdParameters?.path, "/trackings/123456");
		XCTAssertNil(getByIdParameters?.fields);
	}
	
	func testGetTrackingWithOptionalParameters() {
		let requestExpectation = expectationWithDescription("Get Tracking with optional parameters");
		
		var parameters = GetTrackingRequestParameters(slug: "ABC", trackingNumber: "123456", fields: nil);
		parameters?.fields = ["title", "id"];
		parameters?.responseLanguage = "en";
		
		client.getTracking(parameters: parameters!) { (result) in
			AfterShipAssertSuccessResponse(result);
			let lastRequest = self.agent.lastUrlRequest!;
			let url = lastRequest.URL!.absoluteString;
			XCTAssertTrue(url.containsString("https://api.aftership.com/v4"), "Check against the basic things as well");
			XCTAssertEqual(lastRequest.allHTTPHeaderFields?["aftership-api-key"], "AfterShipApiKey");
			XCTAssertEqual(lastRequest.allHTTPHeaderFields?["Content-Type"], "application/json");
			
			XCTAssertTrue(url.containsString("/trackings/ABC/123456"));
			XCTAssertTrue(url.containsString("fields=title,id"), "Should append optional parameters to url");
			XCTAssertTrue(url.containsString("lang=en"));
			requestExpectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testGetTrackingWithAftershipId() {
		let requestExpectation = expectationWithDescription("Get Tracking with Aftership ID");
		
		let parameters = GetTrackingRequestParameters(aftershipId: "123456", fields: nil);
		
		client.getTracking(parameters: parameters!) { (result) in
			AfterShipAssertSuccessResponse(result);
			let lastRequest = self.agent.lastUrlRequest!;
			let url = lastRequest.URL!.absoluteString;
			XCTAssertTrue(url.containsString("/trackings/123456"));
			requestExpectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}
	
	func testGetTrackingBySlugAndTrackingNumber() {
		let requestExpectation = expectationWithDescription("Get Tracking with number and slug");
		
		self.client.getTracking(slug: "Foo", trackingNumber: "123456") { (result) in
			let response = AfterShipAssertSuccessResponse(result).tracking!;
			XCTAssertNotNil(response);
			
			XCTAssertEqual(response.id, "A1B2C3D4", "Make sure the Tracking model is not garbage");
			self.compareDate(response.createdAt!, expectedDateComponents: (2016, 7, 16, 14, 2, 13));
			self.compareDate(response.updatedAt!, expectedDateComponents: (2016, 7, 16, 14, 2, 17));
			XCTAssertEqual(response.slug, "express");
			XCTAssertEqual(response.isActive, false);
			XCTAssertNil(response.pushNotificationAndroidIds, "Empty array should return nil");
			XCTAssertNil(response.customFields);
			XCTAssertNil(response.customerName);
			XCTAssertEqual(response.deliveryTimeInDay, 6);
			XCTAssertNil(response.destinationCountryIsoCode);
			
			XCTAssertEqual(response.emailNotification?.count, 1, "one email notification entry");
			let email = (response.emailNotification?.first)!;
			XCTAssertEqual(email, "foo@bar.com");
			
			XCTAssertEqual(response.expectedDelivery, nil);
			XCTAssertNil(response.pushNotificationIosIds, "Empty array should return nil");
			XCTAssertEqual(response.orderId, "");
			XCTAssertEqual(response.orderIdPath, "");
			XCTAssertEqual(response.shipmentPackageCount, 1);
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
		self.client.getTracking(slug: "Foo", trackingNumber: "") { (result) in
			let error = AfterShipAssertErrorReponse(result);
			XCTAssertNotNil(error);
			emptyTrackingNumberExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
		
		let emptySlugExpectation = expectationWithDescription("Get Tracking with empty slug");
		self.client.getTracking(slug: "", trackingNumber: "123456") { (result) in
			let error = AfterShipAssertErrorReponse(result);
			XCTAssertEqual(error, RequestErrorType.MalformedRequest);
			emptySlugExpectation.fulfill();
		}
		
		self.waitForExpectationsWithTimeout(1, handler: nil);
	}
	
	func testGetTrackingNonJsonResponse() {
		agent.data = "String response".dataUsingEncoding(NSUTF8StringEncoding);
		
		let requestExpectation = expectationWithDescription("Get Tracking with non-json response");
		
		client.getTracking(slug: "Foo", trackingNumber: "123456") { (result) in
			let error = AfterShipAssertErrorReponse(result);
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
		client.getTracking(slug: "Foo", trackingNumber: "123456") { (result) in
			let response = AfterShipAssertSuccessResponse(result).tracking;
			XCTAssertNil(response, "Can't make sense of the response, may be the developer will");
			requestExpectation.fulfill();
		}
		waitForExpectationsWithTimeout(3, handler: nil);
	}	
}
