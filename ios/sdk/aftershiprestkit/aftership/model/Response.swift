//
//  Response.swift
//  aftership
//
//  Created by Kwun Ho Chan on 16/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

/**
	The Response struct provides root properties of AfterShip API response.

	- seealso: [envelope section](https://www.aftership.com/docs/api/4/overview)
	- notes: The response object initialized with metadata and data object unwrapped
*/
public struct Response {
	/**
		The raw values of the response body that returned from AfterShip REST API. (read-only)
	*/
	public let json: [String: AnyObject];
	
	/**
		Extra information about the response.
	*/
	public let metadata: Metadata;
	
	/**
		The Data object of the json body.
	*/
	public let data: [String: AnyObject];
}

public extension Response {
	public var tracking: Tracking? {
		guard let trackingJson = data["tracking"] as? [String: AnyObject] else {
			return nil;
		}
		return Tracking(json: trackingJson);
	}
}

extension Response {
	init?(jsonData: NSData?) {
		guard let data = jsonData,
			let jsonUnwrapped = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject],
			let json = jsonUnwrapped else {
				return nil;
		}
		self.init(json: json);
	}
	
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