//
//  String+DateExtension.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

extension String {
	var dateValue: NSDate? {
		let dateFormats = ["yyyy-MM-dd", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
		let dateFormatter = NSDateFormatter();
		dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0);
		
		for dateFormat in dateFormats {
			dateFormatter.dateFormat = dateFormat;
			if let parsedDate = dateFormatter.dateFromString(self) {
				return parsedDate;
			}
		}
		
		return nil;
	}
}