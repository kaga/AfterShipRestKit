import Foundation
import XCPlayground
import AfterShipRestKit

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true;

//: ## Extending AfterShipClient

//: If the module doesn't have what you are after, you can use the [extensions feature](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html) in swift to support more API endpoints.
extension AfterShipClient {
	func getAllTrackings(completionHandler: PerformRequestCompletionHandler) {
		guard let url = self.createUrlComponents("/trackings").URL else {
			return;
		}
		let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET")
		self.perform(request: request, completionHandler: completionHandler);
	}
}

//: - experiment: Paste your API key here
let apiKey = "";
let client = AfterShipClient(apiKey: apiKey);

client?.getAllTrackings({ (result) in
	switch result {
	case .Success(let response):
		let data = response.data;
		
	case .Error(let errorType):
		errorType;
	}
});

