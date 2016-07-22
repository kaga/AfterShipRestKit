import UIKit
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true;
import AfterShipRestKit

/*:
## Create a Tracking in AfterShip
*/

//: - experiment: Paste your API key here to start creating tracking to AfterShip
let apiKey = "";
let client = AfterShipClient(apiKey: apiKey);

//: ##### There is a convenient version to create a single tracking

//: - experiment: Put a tracking number here and see what happen
let trackingNumber = "";
client?.createTracking(trackingNumber: trackingNumber, completionHandler: { (result) in
	switch result {
	case .Success(let response):
		response.tracking;
	case .Error(let errorType):
		errorType;
	}
});

//: ##### Or create a new tracking recond with a tracking object
var newTracking = Tracking(trackingNumber: trackingNumber);

//: - experiment: You can provide more information about the tracking, try customerName
newTracking?.emailNotification = ["email@abc.com"];


if let newTracking = newTracking {
	client?.createTracking(tracking: newTracking, completionHandler: { (result) in
		switch result {
		case .Success(let response):
			response.tracking;
		case .Error(let errorType):
			errorType;
		}
	});
}

//: [Don't have the feature you wanted? Extend it!](ExtendingClient)

