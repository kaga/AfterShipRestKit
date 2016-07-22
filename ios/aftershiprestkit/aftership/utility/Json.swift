//
//  Json.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

protocol JsonPropertyType {
	var key: String { get };
}

struct Json<MODEL: JsonPropertyType> {
	private var _json: [String: AnyObject];
	
	var json: [String: AnyObject] {
		return _json;
	}
	
	init(json: [String: AnyObject]) {
		self._json = json;
	}
	
	func get<T>(field: MODEL) -> T? {
		return _json[field.key] as? T;
	}
	
	func getArray<T>(field: MODEL) -> Array<T>? {
		guard let unwrappedValue = _json[field.key] as? Array<T> where (unwrappedValue.count > 0) else {
			return nil;
		}
		return unwrappedValue;
	}
	
	mutating func set(field: MODEL, newValue value: AnyObject?) {
		self._json[field.key] = value;
	}
}

