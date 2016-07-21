#AfterShipRestKit

[![Build Status](https://travis-ci.org/kaga/CwwAAQ8BDgsBBwYEBAQKCA.svg?branch=master)](https://travis-ci.org/kaga/CwwAAQ8BDgsBBwYEBAQKCA)
[![codecov](https://codecov.io/gh/kaga/CwwAAQ8BDgsBBwYEBAQKCA/branch/master/graph/badge.svg)](https://codecov.io/gh/kaga/CwwAAQ8BDgsBBwYEBAQKCA)

This module provides a swifty interface to interact with [AfterShip REST API](https://www.aftership.com/docs/api/4). It is also my solution to [one of the AfterShip challanges on GitHub](https://github.com/AfterShip/challenge/tree/mobile-1)

## Use it in your own project

1. Use subtree feature in git to import the project
	
	> git subtree add --prefix frameworks/AfterShipRestKit http://github.com/kaga/CwwAAQ8BDgsBBwYEBAQKCA master --squash
	 	
2. Drag [ios/sdk/aftershiprestkit/aftershiprestkit.xcodeproj](ios/sdk/aftershiprestkit/aftershiprestkit.xcodeproj) into your own project
3. In project setting, add the framework to Embedded Binaries and Linked Frameworks and Libraries to targets that you are intended to use the library. This module supports iOS and watchOS. 

![Step 3 Screenshot](./screenshots/import_frameworks.png)

## Initialize the client
This module is designed to be easy to use with type checking and allow you to extend it for advanced use

	import AfterShipRestKit
	
	let client = AfterShipClient(apiKey: apiKey)
	
By default it uses *NSURLSession.sharedSession()* to perform the request. You can pass in a seperate NSURLSession object to it or simply implementing the RequestAgent interface if you wish to use other network request library.

	let newSession = NSURLSession();
	let anotherClient = AfterShipClient(apiKey: apiKey, requestAgent: newSession);
	
##Get a single tracking

	client.getTracking(slug: slug, trackingNumber: trackingNumber, completionHandler: { (result) in
			switch result {
				case .Success(let response):
					print(response.json);
				case .Error(let errorType):
					print(errorType);
			}
	});
	
Response will be returned as a Successful/Error enumeration. It is recommmended to enumerate both case and avoid the use of default case. 

On successful case, it will return the Response object which you can use its computed properties to retrive the values you need. You can also go straight into the raw object if necessary.
	
	//You can get the raw values for the response
	let json: [String: AnyObject] = response.json;
			
	//Or use the provided helpers
	let tracking = response.tracking;
	let id = tracking?.id;
	let title = tracking?.title;
	
	
For more advanced usage or need to manipulate the optional parameters
	
	if var parameter = GetTrackingRequestParameters(slug: slug, trackingNumber:  trackingNumber,
		fields: [.Title, .AftershipId]) {
		
			// It is perfectly fine to do this if the module doesn't 
			// provide what you need.
			parameter.fields?.append("order_id");
		
			client.getTracking(parameters: parameter, completionHandler: onCompletion)
	}

## Create a tracking

	guard let newTracking = Tracking(trackingNumber: trackingNumber) else {
		return;
	}
	//There is a convenient version as well
	self.client.createTracking(tracking: newTracking, completionHandler: onCompletion);

## Error handling
The client will internally manage the interaction between the client and server side.

#### Rate Limit
The client will refuse to make any request if the user has reached the API's maximum request rate. 

#### Expontential Backoff
If the client has not reached the maximum request rate but the service previously return 429 or 500 errors, a delay will be applied before performing the request. The delay time will be calculated using exponential backoff with jitter.
	
The exponential backoff effect will be reset after inactivity for some time or sevice returned successful response.
 
## Extending the client
You can use the [extensions feature](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html) in swift to support more API endpoints.

	extension AfterShipClient {
		func getAllTrackings(completionHandler: PerformRequestCompletionHandler) {
			guard let url = self.createUrlComponents("/trackings").URL else {
				return;
			}
			let request = self.createUrlRequest(aftershipUrl: url, httpMethod: "GET")
			self.perform(request: request, completionHandler: completionHandler);
		}
	} 

##Demo Project
There is a sample project in [AfterShipApiDemoiOS](ios/aftership.xcworkspace). It requires a AfterShip API key in order to work, [which you can create one here](https://www.aftership.com/apps/api)

##Development
Developer should use [aftership.xcworkspace](ios/aftership.xcworkspace) for development. This module does not depend on anything other than XCode.

###Unit Test
You can run the unit test in XCode without any further setup. It does not requires network connection and AfterShip API key. 

###New File
Remember to add the source file to both iOS and watchOS target.

![New file](./screenshots/add_files.png)