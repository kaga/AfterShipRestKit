//
//  NSMutableURLRequest+Extension.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
	convenience init(aftershipUrl url: NSURL, httpMethod: String, apiKey: String) {
		self.init();
		self.HTTPMethod = httpMethod;
		self.URL = url;
		self.setValue("application/json", forHTTPHeaderField: "Content-Type");
		self.setValue(apiKey, forHTTPHeaderField: "aftership-api-key");
	}
}