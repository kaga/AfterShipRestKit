import Foundation
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true;

/*:
## Initialize AfterShipClient
*/

//Import the module
import AfterShipRestKit

/*:
This module is designed to be easy to use with type checking and allow you to extend it for advanced use.
By default it uses NSURLSession.sharedSession() to perform the request.
*/

let apiKey = "";
let client = AfterShipClient(apiKey: apiKey);
client?.apiHost;
client?.apiKey;
client?.apiVersion;
/*:
You can pass in a seperate NSURLSession object to it
*/
let newSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
let anotherClient = AfterShipClient(apiKey: apiKey, requestAgent: newSession);

/*:
if you wish to use other network request library, or for testing purpose.
It is very simple to implement the RequestAgent interface.
*/
class MockRequestAgent: RequestAgent {
	var mockResponse: Response?;
	
	func perform(request request: NSURLRequest, completionHandler: RequestAgentCompletionHandler) -> Void {
		guard let response = mockResponse else {
			completionHandler(result: .Error(.InvalidJsonData), rateLimit: nil);
			return;
		}
		completionHandler(result: .Success(response: response), rateLimit: nil);
	}
}

let mockRequestAgent = MockRequestAgent();

//: - experiment: Make MockRequestAgent return error.
mockRequestAgent.mockResponse = Response(json: [
	"meta": [
		"code": 200
	],
	"data": [
		"tracking": [
			"id": "1234567890"
		]
	]
	]);

let mockClient = AfterShipClient(apiKey: "apiKey", requestAgent: mockRequestAgent);

/*:
After a client is initialized, we can test the API
*/
mockClient?.getTracking(slug: "ABC", trackingNumber: "1234567890", completionHandler: { (result) in
	switch result {
	case .Success(let response):
		let afterShipId = response.tracking?.id;
		
		break;
	case .Error(let errorType):
		errorType;
		break;
	}
})

//: [Next section we will explore more how you can get a single tracking](GetTracking)
