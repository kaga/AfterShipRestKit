//
//  ExponentialBackoffTest.swift
//  aftership
//
//  Created by Kwun Ho Chan on 18/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class ExponentialBackoffTest: XCTestCase {
	var generator: ExponentialBackoff!;
	
    override func setUp() {
		super.setUp();
		generator = ExponentialBackoff(baseDelayTimeInSeconds: 1, maximumDelayTimeInSeconds: 60);
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGenerateSleepTime() {
		(0...5).forEach { (i) in
			XCTAssertEqual(generator.generateSleepTime(0), 0, "0 attempt should correct to 1st attempt");
		}
		
		(0...5).forEach { (i) in
			XCTAssertEqual(generator.generateSleepTime(-1), 0, "negative attempt value should correct to 1st attempt");
		}
		
		(0...5).forEach { (i) in
			XCTAssertEqual(generator.generateSleepTime(1), 0, "1st attempt value should start immediately");
		}
    }
	
	func testExponentialBackoffAlgorithm() {
		let numberOfSample = 100;
		let averageSleepTime10Attempts = self.averageSleepTime(attempts: 10, numberOfSample: numberOfSample);
		let averageSleepTime5Attempts = self.averageSleepTime(attempts: 5, numberOfSample: numberOfSample);
		let averageSleepTime1Attempt = self.averageSleepTime(attempts: 1, numberOfSample: numberOfSample);
		
		XCTAssertGreaterThan(averageSleepTime10Attempts, 0, "Should delay the user somewhat");
		XCTAssertGreaterThan(averageSleepTime5Attempts, 0, "Should delay the user somewhat");
		XCTAssertEqual(averageSleepTime1Attempt, 0, "1st attempt value should start immediately");
		
		XCTAssertGreaterThan(averageSleepTime10Attempts, averageSleepTime5Attempts,
		                     "average delay time of 10 attempts(\(averageSleepTime10Attempts)) should be longer than 5 attempts(\(averageSleepTime5Attempts))");
		XCTAssertGreaterThan(averageSleepTime5Attempts, averageSleepTime1Attempt);
	}
	
	func averageSleepTime(attempts attempts: Int, numberOfSample: Int) -> NSTimeInterval {
		return (0...numberOfSample).map({ _ in generator.generateSleepTime(attempts) })
			.reduce(Double(0)) { (result, value) -> NSTimeInterval in result + value } / Double(numberOfSample);
	}
}
