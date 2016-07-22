//
//  Tracking.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public struct Tracking {
	private var model: Json<TrackingField>;
	
	public init?(trackingNumber: String) {
		guard (trackingNumber.isEmpty == false) else {
			return nil;
		}
		self.init();
		self.trackingNumber = trackingNumber;
	}
	
	public init(json: [String: AnyObject]) {
		self.model = Json(json: json);
	}
	
	init() {
		self.model = Json(json: [String: AnyObject]());
	}
}

public extension Tracking {
	public var json: [String: AnyObject] {
		return model.json;
	}
	
	public var id: String? {
		get {
			return model.get(.AftershipId)
		}
	}
	
	public var trackingNumber: String? {
		get {
			return model.get(.TrackingNumber);
		}
		set(newValue) {
			model.set(.TrackingNumber, newValue: newValue);
		}
	}
	
	public var createdAt: NSDate? {
		get {
			let dateString: String? = model.get(.CreatedAt);
			return dateString?.dateValue;
		}
	}
	
	public var updatedAt: NSDate? {
		get {
			let dateString: String? = model.get(.UpdatedAt)
			return dateString?.dateValue;
		}
	}
	
	public var trackingPostalCode: String? {
		get {
			return model.get(.TrackingPostalCode);
		}
		set(newValue) {
			model.set(.TrackingPostalCode, newValue: newValue);
		}
	}
	
	public var trackingShipDate: NSDate? {
		get {
			guard let dateString: String = model.get(.TrackingShipDate) else {
				return nil;
			}
			
			let dateFormatter = NSDateFormatter.yyyymmddFormatter();
			return dateFormatter.dateFromString(dateString);
		}
		set(newValue) {
			let dateFormatter = NSDateFormatter.yyyymmddFormatter();
			if let date = newValue {
				let formattedString = dateFormatter.stringFromDate(date)
				model.set(.TrackingShipDate, newValue: formattedString);
			}
		}
	}
	
	public var trackingAccountNumber: String? {
		get {
			return model.get(.TrackingAccountNumber);
		}
		set(newValue) {
			model.set(.TrackingAccountNumber, newValue: newValue);
		}
	}
	
	public var trackingKey: String? {
		get {
			return model.get(.TrackingKey);
		}
		set(newValue) {
			model.set(.TrackingKey, newValue: newValue);
		}
	}
	
	public var trackingDestinationCountry: String? {
		get {
			return model.get(.TrackingDestinationCountry)
		}
		set(newValue) {
			model.set(.TrackingDestinationCountry, newValue: newValue);
		}
	}
	
	public var slug: String? {
		get {
			return model.get(.Slug);
		}
		set(newValue) {
			model.set(.Slug, newValue: newValue);
		}
	}
	
	public var isActive: Bool? {
		get {
			return model.get(.Active);
		}
	}
	
	public var customFields: [String: AnyObject]? {
		get {
			return model.get(.CustomFields);
		}
		set {
			return model.set(.CustomFields, newValue: newValue);
		}
	}
	
	public var customerName: String? {
		get {
			return model.get(.CustomerName)// json["customer_name"] as? String
		}
		set(newValue) {
			model.set(.CustomerName, newValue: newValue);
		}
	}
	
	public var deliveryTimeInDay: Int? {
		get {
			return model.get(.DeliveryTimeInDay);
		}
	}
	
	public var destinationCountryIsoCode: String? {
		get {
			return model.get(.DestinationCountryIsoCode);
		}
		set(newValue) {
			model.set(.DestinationCountryIsoCode, newValue: newValue);
		}
	}
	
	public var expectedDelivery: NSDate? {
		get {
			let dateString: String? = model.get(.ExpectedDelivery);
			return dateString?.dateValue;
		}
	}
	
	public var orderId: String? {
		get {
			return model.get(.OrderId);
		}
		set(newValue) {
			model.set(.OrderId, newValue: newValue);
		}
	}
	
	public var orderIdPath: String? {
		get {
			return model.get(.OrderIdPath);
		}
		set(newValue) {
			model.set(.OrderIdPath, newValue: newValue);
		}
	}
	
	public var originCountryIsoCode: String? {
		get {
			return model.get(.OriginCountryIsoCode);
		}
	}
	
	public var uniqueToken: String? {
		get {
			return model.get(.UniqueToken);
		}
	}
	
	public var signedBy: String? {
		get {
			return model.get(.SignedBy);
		}
	}
	
	public var source: String? {
		get {
			return model.get(.Source);
		}
	}
	
	public var tag: TrackingStatus? {
		get {
			guard let tagCode: String = model.get(.Tag),
				let tag = TrackingStatus(rawValue: tagCode) else {
					return nil;
			}
			return tag;
		}
	}
	
	public var title: String? {
		get {
			return model.get(.Title);
		}
		set(newValue) {
			model.set(.Title, newValue: newValue);
		}
	}
	
	public var trackedCount: Int? {
		get {
			return model.get(.TrackedCount);
		}
	}
	
	public var checkpoints: [Checkpoint]? {
		get {
			let checkpointsJson: [[String: AnyObject]]? = model.get(.Checkpoints);
			return checkpointsJson?.map(Checkpoint.init(json:));
		}
	}
}

//MARK: - Notifications 
public extension Tracking {
	public var pushNotificationAndroidIds: [String]? {
		get {
			return model.getArray(.PushNotificationAndroidIds);
		}
		set(newValue) {
			model.set(.PushNotificationAndroidIds, newValue: newValue);
		}
	}
	
	public var pushNotificationIosIds: [String]? {
		get {
			return model.getArray(.PushNotificationIosIds);
		}
		set(newValue) {
			model.set(.PushNotificationIosIds, newValue: newValue);
		}
	}
	
	public var smsNotificationPhoneNumbers: [String]? {
		get {
			return model.getArray(.SmsNotificationPhoneNumbers);
		}
		set(newValue) {
			model.set(.SmsNotificationPhoneNumbers, newValue: newValue);
		}
	}
	
	public var emailNotification: [String]? {
		get {
			return model.getArray(.Emails);
		}
		set(newValue) {
			model.set(.Emails, newValue: newValue);
		}
	}
}

//MARK: - Shipment
public extension Tracking {
	public var shipment: (type: String, weight: Double, unit: String, packageCount: Int)? {
		guard let packageCount = shipmentPackageCount,
			let type = shipmentType,
			let weight = shipmentWeight,
			let unit = shipmentWeightUnit else {
				return nil;
		}
		return (type: type, weight: weight, unit: unit, packageCount: packageCount);
	}
	
	var shipmentPackageCount: Int? {
		get {
			return model.get(.ShipmentPackageCount);
		}
	}
	
	var shipmentType: String? {
		get {
			return model.get(.ShipmentType);
		}
	}
	
	var shipmentWeight: Double? {
		get {
			return model.get(.ShipmentWeight);
		}
	}
	
	var shipmentWeightUnit: String? {
		get {
			return model.get(.ShipmentWeightUnit);
		}
	}
}