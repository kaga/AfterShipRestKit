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
		self.setValue("aftership-restkit \(NSBundle.AftershipRestKitBundle().versionBuild)", forHTTPHeaderField: "aftership-user-agent");
	}
	
	func setAftershipHeaderFields(apiKey: String) {
		self.setValue("application/json", forHTTPHeaderField: "Content-Type");
		self.setValue(apiKey, forHTTPHeaderField: "aftership-api-key");
		self.setValue("aftership-restkit \(NSBundle.AftershipRestKitBundle().versionBuild)", forHTTPHeaderField: "aftership-user-agent");
	}
}

extension NSBundle {
	var versionBuild: String {
		let version = self.applicationVersion;
		let build = self.applicationBuild;
		return "\(version).\(build)";
	}
	
	private var applicationVersion:String {
		return self.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
	}
	
	private var applicationBuild: String {
		return self.objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
	}
	
	static func AftershipRestKitBundle() -> NSBundle {
		return NSBundle(identifier: "com.aftership.sdk.restkit")!;
	}
}