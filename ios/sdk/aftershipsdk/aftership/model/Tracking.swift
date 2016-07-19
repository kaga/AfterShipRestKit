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
	
	init() {
		self.model = Json(json: [String: AnyObject]());
	}
	
	init(json: [String: AnyObject]) {
		self.model = Json(json: json);
	}
}

public enum TrackingField: String {
	case AftershipId = "id";
	case TrackingNumber = "tracking_number";
	case CreatedAt = "created_at";
	case UpdatedAt = "updated_at";
	case TrackingPostalCode = "tracking_postal_code";
	case TrackingShipDate = "tracking_ship_date";
	case TrackingAccountNumber = "tracking_account_number";
	case TrackingKey = "tracking_key";
	case TrackingDestinationCountry = "tracking_destination_country";
	case Slug = "slug";
	case Active = "active";
	case PushNotificationAndroidIds = "android";
	case PushNotificationIosIds = "ios";
	case SmsNotificationPhoneNumbers = "smses";
	case Emails = "emails";
	case CustomFields = "custom_fields";
	case CustomerName = "customer_name";
	case DeliveryTimeInDay = "delivery_time";
	case DestinationCountryIsoCode = "destination_country_iso3";
	case ExpectedDelivery = "expected_delivery";
	case OrderId = "order_id";
	case OrderIdPath = "order_id_path";
	case OriginCountryIsoCode = "origin_country_iso3";
	case UniqueToken = "unique_token";
	case ShipmentPackageCount = "shipment_package_count";
	case ShipmentType = "shipment_type";
	case ShipmentWeight = "shipment_weight";
	case ShipmentWeightUnit = "shipment_weight_unit";
	case SignedBy = "signed_by";
	case Source = "source";
	case Tag = "tag";
	case Title = "title";
	case TrackedCount = "tracked_count";
	case Checkpoints = "checkpoints";
}

extension TrackingField: JsonPropertyType {
	var key: String {
		return self.rawValue;
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
		set(newValue) {
			model.set(.AftershipId, newValue: newValue);
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
		set(newValue) {
			model.set(.CreatedAt, newValue: newValue?.isoString);
		}
	}
	
	public var updatedAt: NSDate? {
		get {
			let dateString: String? = model.get(.UpdatedAt)
			return dateString?.dateValue;
		}
		set(newValue) {
			model.set(.UpdatedAt, newValue: newValue?.isoString);
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
			let dateString: String? = model.get(.TrackingShipDate);
			return dateString?.dateValue;
		}
		set(newValue) {
			model.set(.TrackingShipDate, newValue: newValue?.isoString);
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
	
	public var active: Bool? {
		get {
			return model.get(.Active);
		}
		set(newValue) {
			model.set(.Active, newValue: newValue);
		}
	}
	
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
	
	public var emails: [String]? {
		get {
			return model.getArray(.Emails);
		}
		set(newValue) {
			model.set(.Emails, newValue: newValue);
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
		set(newValue) {
			model.set(.DeliveryTimeInDay, newValue: newValue);
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
			return model.get(.ExpectedDelivery);
		}
		set(newValue) {
			model.set(.ExpectedDelivery, newValue: newValue);
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
		set(newValue) {
			model.set(.OriginCountryIsoCode, newValue: newValue);
		}
	}
	
	public var uniqueToken: String? {
		get {
			return model.get(.UniqueToken);
		}
		set(newValue) {
			model.set(.UniqueToken, newValue: newValue);
		}
	}
	
	public var shipmentPackageCount: Int? {
		get {
			return model.get(.ShipmentPackageCount);
		}
		set(newValue) {
			model.set(.ShipmentPackageCount, newValue: newValue);
		}
	}
	
	public var shipmentType: String? {
		get {
			return model.get(.ShipmentType);
		}
		set(newValue) {
			model.set(.ShipmentType, newValue: newValue);
		}
	}
	
	public var shipmentWeight: Double? {
		get {
			return model.get(.ShipmentWeight);
		}
		set(newValue) {
			model.set(.ShipmentWeight, newValue: newValue);
		}
	}
	
	public var shipmentWeightUnit: String? {
		get {
			return model.get(.ShipmentWeightUnit);
		}
		set(newValue) {
			model.set(.ShipmentWeightUnit, newValue: newValue);
		}
	}
	
	public var signedBy: String? {
		get {
			return model.get(.SignedBy);
		}
		set(newValue) {
			model.set(.SignedBy, newValue: newValue);
		}
	}
	
	public var source: String? {
		get {
			return model.get(.Source);
		}
		set(newValue) {
			model.set(.Source, newValue: newValue);
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
		set(newValue) {
			model.set(.Tag, newValue: newValue?.rawValue);
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
		set(newValue) {
			model.set(.TrackedCount, newValue: newValue);
		}
	}
	
	public var checkpoints: [Checkpoint]? {
		get {
			let checkpointsJson: [[String: AnyObject]]? = model.get(.Checkpoints);
			return checkpointsJson?.map(Checkpoint.init(json:));
		}
	}
}