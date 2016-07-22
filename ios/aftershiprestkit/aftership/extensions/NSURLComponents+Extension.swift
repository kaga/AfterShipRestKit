//
//  NSURLComponents+Extension.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension NSURLComponents {
	convenience init(aftershipHost host: String, path: String, apiVersion: Int) {
		self.init();
		self.scheme = "https";
		self.host = host;
		self.path = "/v\(apiVersion)\(path)";
	}
}