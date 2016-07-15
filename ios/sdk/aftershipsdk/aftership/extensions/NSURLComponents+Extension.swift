//
//  NSURLComponents+Extension.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension NSURLComponents {
	convenience init(aftershipHost host: String, path: String, apiVersion: Int?) {
		self.init();
		self.scheme = "https";
		self.host = host;
		if let apiVersion = apiVersion {
			self.path = "/v\(apiVersion)/\(path)";
		} else {
			self.path = path;
		}
	}
}