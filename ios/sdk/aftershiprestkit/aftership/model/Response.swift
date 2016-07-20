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
	public var rateLimit: RateLimit?;
	
	init?(json: [String: AnyObject], rateLimit: RateLimit? = nil) {
		self.json = json;
		
		guard let metadataJson = json["meta"] as? [String: AnyObject],
		let dataJson = json["data"] as? [String: AnyObject] else {
			return nil;
		}
		self.metadata = Metadata(json: metadataJson);
		self.data = dataJson;
		self.rateLimit = rateLimit;
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

extension Response {
	init?(jsonData: NSData?, rateLimit: RateLimit? = nil) {
		guard let data = jsonData,
			let jsonUnwrapped = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject],
			let json = jsonUnwrapped else {
				return nil;
		}
		self.init(json: json, rateLimit: rateLimit);
	}
}