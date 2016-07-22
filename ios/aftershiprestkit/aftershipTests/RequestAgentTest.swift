//
//  RequestAgentTest.swift
//  aftershiprestkit
//
//  Created by Kwun Ho Chan on 21/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import XCTest
@testable import AfterShipRestKit

class RequestAgentTest_NSURLSessionImplementation: XCTestCase {
	
	func testProcessResponse() {
		let urlSession = NSURLSession.sharedSession();
		
		AfterShipAssertErrorReponse(urlSession.processResponse(nil, response: NSURLResponse(), error: nil).result,
		                            "No data and non HTTP URL Response");
		
		
		let testData = getTestJsonData("Demo_CreateTracking_Response_Body");
		let nonHttpUrlResponseError = AfterShipAssertErrorReponse(urlSession.processResponse(testData, response: nil, error: nil).result)
		XCTAssertEqual(nonHttpUrlResponseError, RequestErrorType.UnsupportedType, "No data and non HTTP URL Response");
		
		let postTrackingUrl = NSURL(string: "https://api.aftership.com/v4/trackings")!;
		let httpUrlResponse = NSHTTPURLResponse(URL: postTrackingUrl, statusCode: 200, HTTPVersion: nil, headerFields: nil);
		let createTrackingResponse = urlSession.processResponse(testData, response: httpUrlResponse, error: nil);
		AfterShipAssertSuccessResponse(createTrackingResponse.result, "Test mock POST /trackings response");
	}
	
	func testProcessResponseWithNonJsonBody() {
		let urlSession = NSURLSession.sharedSession();
		
		let body = "hello world".dataUsingEncoding(NSUTF8StringEncoding);
		let postTrackingUrl = NSURL(string: "https://api.aftership.com/v4/trackings")!;
		
		let tests = [(200, RequestErrorType.InvalidJsonData),
		             (400, RequestErrorType.MalformedRequest),
		             (500, RequestErrorType.ServiceInternalError)];
		tests.forEach { (statusCode, expectedErrorType) in
			let httpUrlResponse = NSHTTPURLResponse(URL: postTrackingUrl, statusCode: statusCode, HTTPVersion: nil, headerFields: nil);
			let (result, _) = urlSession.processResponse(body, response: httpUrlResponse, error: nil);
			let errorType = AfterShipAssertErrorReponse(result);
			XCTAssertEqual(errorType, expectedErrorType, "Expected \(expectedErrorType) with status code \(statusCode)");
		}
	}
	
	func testProcessResponseWithAftershipError() {
		let urlSession = NSURLSession.sharedSession();

		let testData = getTestJsonData("Demo_CreateTracking_Error");
		let postTrackingUrl = NSURL(string: "https://api.aftership.com/v4/trackings")!;
		let httpUrlResponse = NSHTTPURLResponse(URL: postTrackingUrl, statusCode: 400, HTTPVersion: nil, headerFields: nil);
		let (result, _) = urlSession.processResponse(testData, response: httpUrlResponse, error: nil);
		let errorType = AfterShipAssertErrorReponse(result);
		XCTAssertEqual(errorType, RequestErrorType.MalformedRequest);
	}
	
	func getTestJsonData(fileName: String) -> NSData {
		let url = NSBundle(forClass: self.dynamicType).URLForResource(fileName, withExtension: "json", subdirectory: nil);
		return NSData(contentsOfURL: url!)!;
	}
}
