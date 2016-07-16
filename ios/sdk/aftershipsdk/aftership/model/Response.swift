//
//  Response.swift
//  aftership
//
//  Created by Kwun Ho Chan on 16/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public struct Response {
	public var json: [String: AnyObject];
	public var metadata: Metadata;
	public var data: [String: AnyObject];
	
	init?(json: [String: AnyObject]) {
		self.json = json;
		
		guard let metadataJson = json["meta"] as? [String: AnyObject],
		let dataJson = json["data"] as? [String: AnyObject] else {
			return nil;
		}
		self.metadata = Metadata(json: metadataJson);
		self.data = dataJson;
	}
}

public extension Response {
	public var tracking: Tracking? {
		guard let dataJson = json["data"] as? [String: AnyObject],
			let trackingJson = dataJson["tracking"] as? [String: AnyObject] else {
				return nil;
		}
		return Tracking(json: trackingJson);
	}
}

public struct Metadata {
	public var json: [String: AnyObject];
	public var code: Int?;
	
	init(json: [String: AnyObject]) {
		self.json = json;
		self.code = json["code"] as? Int;
	}
}