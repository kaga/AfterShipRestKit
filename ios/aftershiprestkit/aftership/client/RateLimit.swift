//
//  RateLimit.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public struct RateLimit {
	let resetDate: NSDate;
	let remaining: Int;
	let limit: Int;
};