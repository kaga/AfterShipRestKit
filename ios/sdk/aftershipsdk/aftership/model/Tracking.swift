//
//  Tracking.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public struct Tracking {
	public let json: [String: AnyObject];
	
	public let createdAt: NSDate?;
	public let updatedAt: NSDate?;
	public let id: String?;
	
	public let trackingPostalCode: String?;
	public let trackingShipDate: NSDate?;
	public let trackingAccountNumber: String?;
	public let trackingKey: String?;
	public let trackingDestinationCountry: String?;
	public let slug: String?;
	public let active: Bool?;
	
	public let pushNotificationAndroidIds: [String]?;
	public let pushNotificationIosIds: [String]?;
	public let smsNotificationPhoneNumbers: [String]?; //Phone number object?
	
	public let customFields: AnyObject? = nil;
	public let customerName: String?;
	public let deliveryTimeInDay: Int?;
	public let destinationCountryIsoCode: String?;
	public let emails: [String]?;
	public let expectedDelivery: NSDate?;
	
	public let orderId: String?;
	public let orderIdPath: String?;
	public let originCountryIsoCode: String?;
	public let uniqueToken: String?;
	public let shipmentPackageCount: Int?;
	public let shipmentType: String?;
	public let shipmentWeight: Double?;
	public let shipmentWeightUnit: String?;
	public let signedBy: String?;
	
	public let source: String?;
	public let tag: TrackingStatus?;
	public let title: String?;
	public let trackedCount: Int?;
	public let checkpoints: [Checkpoint]?;
	
	init(json: [String: AnyObject]) {
		self.json = json;
		
		self.createdAt = (json["created_at"] as? String)?.dateValue;
		self.updatedAt = (json["updated_at"] as? String)?.dateValue;
		self.id = json["id"] as? String;
		
		self.trackingPostalCode = json["tracking_postal_code"] as? String;
		self.trackingShipDate = (json["tracking_ship_date"] as? String)?.dateValue;
		self.trackingAccountNumber = json["tracking_account_number"] as? String;
		self.trackingKey = json["tracking_key"] as? String;
		self.trackingDestinationCountry = json["tracking_destination_country"] as? String;
		self.slug = json["slug"] as? String;
		self.active = json["active"] as? Bool;
		
		self.pushNotificationAndroidIds = unwrapArray(json["android"])// as? [String];
		self.pushNotificationIosIds = unwrapArray(json["ios"])// as? [String];
		self.smsNotificationPhoneNumbers = unwrapArray(json["smses"])// as? [String];
		self.emails = unwrapArray(json["emails"])// as? [String];
		
		self.customerName = json["customer_name"] as? String;
		self.deliveryTimeInDay = json["delivery_time"] as? Int;
		self.destinationCountryIsoCode = json["destination_country_iso3"] as? String;
		self.expectedDelivery = (json["expected_delivery"] as? String)?.dateValue;
		
		self.orderId = json["order_id"] as? String;
		self.orderIdPath = json["order_id_path"] as? String;
		self.originCountryIsoCode = json["origin_country_iso3"] as? String;
		self.uniqueToken = json["unique_token"] as? String;
		
		self.shipmentPackageCount = json["shipment_package_count"] as? Int;
		self.shipmentType = json["shipment_type"] as? String;
		self.shipmentWeight = json["shipment_weight"] as? Double;
		self.shipmentWeightUnit = json["shipment_weight_unit"] as? String;
		self.signedBy = json["signed_by"] as? String;
		self.source = json["source"] as? String;
		
		if let tagCode = json["tag"] as? String,
			let tag = TrackingStatus(rawValue: tagCode) {
			self.tag = tag
		} else {
			self.tag = nil;
		}
		
		self.title = json["title"] as? String;
		self.trackedCount = json["tracked_count"] as? Int;
		self.checkpoints = (json["checkpoints"] as? [[String: AnyObject]])?.map(Checkpoint.init(json:));
	}
}

func unwrapArray<T>(object: AnyObject?) -> Array<T>? {
	guard let unwrappedValue = object as? Array<T> where (unwrappedValue.count > 0) else {
		return nil;
	}
	return unwrappedValue;
}

//func unwrapValue<T>(object: AnyObject?) -> T? {
//	guard let unwrappedValue = object as? T else {
//		return nil;
//	}
//	
//	switch unwrappedValue {
//	case let value as String where value.isEmpty:
//		return nil;
//	default:
//		return unwrappedValue;
//	}
//}

