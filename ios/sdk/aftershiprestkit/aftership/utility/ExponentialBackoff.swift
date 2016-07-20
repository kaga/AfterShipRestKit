//
//  ExponentialBackoff.swift
//  aftership
//
//  Created by Kwun Ho Chan on 18/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

struct ExponentialBackoff {
	var baseDelayTimeInSeconds: NSTimeInterval = 1;
	var maximumDelayTimeInSeconds: NSTimeInterval;
	
	func generateSleepTime(attempt: Int) -> NSTimeInterval {
		guard attempt > 1 else {
			return 0;
		}
		
		let backoffTimeInSeconds: UInt32 = min(UInt32(maximumDelayTimeInSeconds),
		                                       UInt32(baseDelayTimeInSeconds * pow(Double(2), Double(attempt))));
		return NSTimeInterval(arc4random_uniform(backoffTimeInSeconds));
	}
}
