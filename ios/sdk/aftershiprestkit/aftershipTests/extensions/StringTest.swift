//
//  StringTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

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