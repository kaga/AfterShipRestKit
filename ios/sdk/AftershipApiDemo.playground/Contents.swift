import UIKit
import AfterShipRestKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true;

let apiKey = "";

let client = AftershipClient(apiKey: apiKey);

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

//You can extend this api easily
struct GetTrackingsResponse {
	var json: [String: AnyObject];
	
	var trackings: [Tracking]? {
		return (json["trackings"] as? [[String: AnyObject]])?.map(Tracking.init(json:));
	}
}

client?.performRequest("/trackings") { (result) in
	switch result {
	case .Success(let response):
		let trackings = GetTrackingsResponse(json: response.data).trackings;
		print("\(trackings?.count) Trackings");
		break;
	case .Error(let errorType):
		print(errorType);
		break;
	}
}
