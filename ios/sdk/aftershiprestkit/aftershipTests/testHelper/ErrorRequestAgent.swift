//
//  ErrorRequestAgent.swift
//  aftership
//
//  Created by Kwun Ho Chan on 19/07/16.
//  Copyright © 2016 kaga. All rights reserved.
//

import Foundation
@testable import AfterShipRestKit

class ErrorRequestAgent: RequestAgent {
	var errorType: RequestErrorType = .ServiceInternalError;
	func perform(request request: NSURLRequest, completionHandler: RequestAgentCompletionHandler) -> Void {
		completionHandler(result: .Error(errorType));
	}
}