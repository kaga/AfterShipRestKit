//
//  AftershipAssert.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

func AftershipAssertSuccessResponse<T>(result: RequestResult<T>) -> T! {
	switch result {
	case .Success(let response):
		return response;
	default:
		XCTFail();
	}
	return nil;
}

func AftershipAssertErrorReponse<T>(result: RequestResult<T>) -> RequestErrorType! {
	switch result {
	case .Error(let errorType):
		return errorType;
	default:
		XCTFail();
	}
	return nil;
}

extension XCTestCase {
	func compareDate(date: NSDate, expectedDateComponents components: (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)) -> NSComparisonResult {
		let expectedDateComponents = NSDateComponents();
		expectedDateComponents.timeZone = NSTimeZone(forSecondsFromGMT: 0);
		expectedDateComponents.year = components.year;
		expectedDateComponents.month = components.month;
		expectedDateComponents.day = components.day;
		expectedDateComponents.hour = components.hour;
		expectedDateComponents.minute = components.minute;
		expectedDateComponents.second = components.second;
		
		let calendar = NSCalendar.currentCalendar();
		let expectedDate = calendar.dateFromComponents(expectedDateComponents)!;
		return calendar.compareDate(date, toDate: expectedDate, toUnitGranularity: .Second);
	}
}