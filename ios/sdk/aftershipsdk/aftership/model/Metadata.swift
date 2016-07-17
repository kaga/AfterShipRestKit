//
//  Metadata.swift
//  aftership
//
//  Created by Kwun Ho Chan on 17/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public enum MetadataType: String {
	case BadRequest;
	case Unauthorized;
	case Forbidden;
	case NotFound;
	case TooManyRequests;
	case InternalError;
}

public struct Metadata {
	public var json: [String: AnyObject];
	public let code: Int?;
	public let message: String?;
	public let type: MetadataType?;
	
	init(json: [String: AnyObject]) {
		self.json = json;
		self.code = json["code"] as? Int;
		self.message = json["message"] as? String;
		
		if let typeRawValue = json["type"] as? String,
			let type = MetadataType(rawValue: typeRawValue){
			self.type = type;
		} else {
			self.type = nil;
		}
		
	}
}