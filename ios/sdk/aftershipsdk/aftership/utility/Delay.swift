//
//  Delay.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

func delay(delayInSeconds:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delayInSeconds * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}