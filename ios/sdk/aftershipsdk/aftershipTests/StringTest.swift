//
//  StringTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShip

class StringTest: XCTestCase {

	func testValidDateParsing() {
		let dateStrings = ["2016-07-15",  "2016-07-15T00:00:00",  "2016-07-15T00:00:00+00:00", "2016-07-15T12:00:00+12:00"]
		
		dateStrings.forEach { (dateString) in
			let compareDateResult = compareDate(dateString.dateValue!, expectedDateComponents: (2016, 7, 15, 0, 0, 0));
			XCTAssertEqual(compareDateResult, NSComparisonResult.OrderedSame, "Assume dates are in UTC format");
		}
	}
	
	func testInvalidDateStringParsing() {
		XCTAssertNil("".dateValue, "Empty string is not a date");
		XCTAssertNil("Foo".dateValue, "Foo is not a date");
	}

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
