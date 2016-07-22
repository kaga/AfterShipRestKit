//
//  NSMutableURLRequest+Extension.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
	func setAftershipHeaderFields(apiKey: String) {
		self.setValue("application/json", forHTTPHeaderField: "Content-Type");
		self.setValue(apiKey, forHTTPHeaderField: "aftership-api-key");
		self.setValue("aftership-restkit \(NSBundle.AftershipRestKitBundle().versionBuild)", forHTTPHeaderField: "aftership-user-agent");
	}
}