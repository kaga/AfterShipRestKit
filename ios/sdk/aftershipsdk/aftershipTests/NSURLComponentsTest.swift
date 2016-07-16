//
//  NSURLComponentsTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 15/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShip

class NSURLComponentsTest: XCTestCase {
    func testV4GetTrackingsUrl() {
		let components = NSURLComponents(aftershipHost: "api.aftership.com", path: "trackings", apiVersion: 4);
		XCTAssertEqual(components.URL?.absoluteString, "https://api.aftership.com/v4/trackings", "Should support existing api format");
	}
}
