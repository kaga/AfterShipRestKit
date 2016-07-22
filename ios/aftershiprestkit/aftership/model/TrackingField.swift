//
//  TrackingField.swift
//  aftershiprestkit
//
//  Created by Kwun Ho Chan on 21/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

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