//
//  Checkpoint.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public struct Checkpoint {
	public let json: [String: AnyObject];
	
	public let slug: String?;
	public let city: String?;
	public let location: String?; //Available in REST API, missing in documentation
	
	public let createdAt: NSDate?;
	public let checkPointTime: NSDate?;
	
	public let message: String?;
	public let tag: TrackingStatus?;
	
	public let countryIsoCode: String?;
	public let countryName: String?;
	public let state: String?;
	public let zip: String?;
	
	init(json: [String: AnyObject]) {
		self.json = json;
		
		self.slug = json["slug"] as? String;
		self.city = json["city"] as? String;
		self.location = json["location"] as? String;
		
		self.createdAt = (json["created_at"] as? String)?.dateValue;
		self.checkPointTime = (json["checkpoint_time"] as? String)?.dateValue;
		
		self.message = json["message"] as? String;
		
		if let tagCode = json["tag"] as? String,
			let tag = TrackingStatus(rawValue: tagCode) {
			self.tag = tag
		} else {
			self.tag = nil;
		}
		
		self.countryIsoCode = json["country_iso3"] as? String;
		self.countryName = json["country_name"] as? String;
		self.state = json["state"] as? String;
		self.zip = json["zip"] as? String;
	}
}