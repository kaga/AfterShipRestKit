//
//  TrackingStatus.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation

public enum TrackingStatus: String {
	case Pending;
	case InfoReceived;
	case InTransit
	case OutForDelivery;
	case AttemptFail;
	case Delivered;
	case Exception;
	case Expired;
}