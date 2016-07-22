import Foundation
import XCPlayground
import AfterShipRestKit

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true;

/*:
## Get a Single Tracking
*/

//: - experiment: Paste your API key here 
let apiKey = "";
let client = AfterShipClient(apiKey: apiKey);


//: ##### There is a convenient version to get a single tracking
//: - experiment: Put a courier and tracking number and see what happen
let courier = "";//for example "dhl"
let trackingNumber = "";
client?.getTracking(slug: courier, trackingNumber: trackingNumber, completionHandler: { (result) in
	switch result {
	case .Success(let response):
		let tracking = response.tracking;
		let id = tracking?.id;
		let title = tracking?.title;
	case .Error(let errorType):
		errorType;
	}
});

/*:
##### There is a *GetTrackingRequestParameters* struct which you can configure all the parameters
*/
let getByAftershipId = GetTrackingRequestParameters(aftershipId: "123456");
let getBySlugAndTrackingNumber = GetTrackingRequestParameters(slug: "dhl", trackingNumber: "123456");

//: The fields parameters have a friendly enum
var getWithOptionalFields = GetTrackingRequestParameters(aftershipId: "123456",
                                                         fieldsToResponse: [.Title, .AftershipId]);

//: It is perfectly fine to do this if the TrackingField enum doesn't provide what you need.
getWithOptionalFields?.fields?.append("order_id");

//*: ##### Now you can get tracking with the request parameter
if let requestParameters = getByAftershipId {
	client?.getTracking(parameters: requestParameters, completionHandler: { (result) in
		switch result {
		case .Success(let response):
			let tracking = response.tracking;
			let id = tracking?.id;
		case .Error(let errorType):
			errorType;
		}
	})
}

//: [Want to crate a tracking? See the next section](CreateTracking)
