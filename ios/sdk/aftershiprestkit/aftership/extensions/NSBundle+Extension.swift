//
//  NSBundle+Extension.swift
//  aftershiprestkit
//
//  Created by Kwun Ho Chan on 20/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

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