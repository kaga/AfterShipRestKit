import UIKit
import AfterShipRestKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true;

let apiKey = "";

let client = AfterShipClient(apiKey: apiKey);

client?.getTracking(trackingNumber: "", slug: "") { (result) in
	switch result {
	case .Success(let tracking):
		break;
	case .Error(let errorType):
		print(errorType);
		break;
	}
}

client?.createTracking(trackingNumber: "") { (result) in
	switch result {
	case .Success(let tracking):
		break;
	case .Error(let errorType):
		print(errorType);
		break;
	}
}

let url = client?.createUrlComponents("/trackings").URL!;
let request = client!.createUrlRequest(aftershipUrl: url!, httpMethod: "GET");
client?.performRequest(request: request) { (result) in
	switch result {
	case .Success(let response):
//		let data = try! NSJSONSerialization.dataWithJSONObject(response.json, options: .PrettyPrinted);
		print(response.json)
		break;
	default:
		break;
	}
}
