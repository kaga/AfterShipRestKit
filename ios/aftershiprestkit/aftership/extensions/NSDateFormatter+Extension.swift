//
//  NSDateFormatter+Extension.swift
//  aftershiprestkit
//
//  Created by Kwun Ho Chan on 20/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension NSDateFormatter {
	static func yyyymmddFormatter() -> NSDateFormatter {
		let dateFormatter = NSDateFormatter();
		dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX");
		dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT");
		dateFormatter.dateFormat = "yyyyMMdd";
		return dateFormatter;
	}
}
