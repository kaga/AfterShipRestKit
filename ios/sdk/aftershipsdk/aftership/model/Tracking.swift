//
//  Tracking.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public struct Tracking {
	let json: [String: AnyObject];
	
	//	let createdAt: NSDate?;
	//	let updatedAt: NSDate?;
	//	let id: String?;
	//	let trackingPostalCode: String?;
	//	let trackingShipDate: String?;
	//	let trackingAccountNumber: String?;
	//	let trackingKey: String?;
	//	let trackingDestinationCountry: String?;
	//	let slug: String?;
	//	let active: Bool?;
	//
	//	let pushNotificationAndroidIds: [String]?;
	//	let pushNotificationIosIds: [String]?;
	//	let smsNotificationPhoneNumbers: [String]?; //Phone number object?
	//
	////	let customFields:
	//	let customerName: String?;
	//	let deliveryTime: String?;
	//	let destinationCountryIsoCode: String?;
	//	let emails: [String]?;
	//	let expectedDelivery: String?;
	//
	//	let orderId: String?;
	//	let orderIdPath: String?;
	//	let originCountryISO3: String?;
	//	let uniqueToken: String?;
	//	let shipmentPackageCount: Int?;
	//	let shipmentType: String?;
	//	let shipmentWeight: Double?;
	//	let shipmentWeightUnit: String?;
	//	let signedBy: String?;
	//
	//	let source: String?;
	//	let tag: TrackingStatus?;
	//	let title: String?;
	//	let trackedCount: Int?;
	//	let checkpoints: [Checkpoint]?;
	
	init(json: [String: AnyObject]) {
		self.json = json;
	}
}