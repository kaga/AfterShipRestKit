import Foundation
import XCPlayground
@testable import AfterShipRestKit

/*:
The client will internally manage the interaction between the client and server side.

#### Expontential Backoff
When interacting with a network service, it is generally a good idea not too make many request at the same time.
It is particularly true when the service is unavaiable and millions of devices start pinging the server to dealth just when the service is back online again.
This is where expontential backoff comes in, which a delay time will be applied before performing the request.

The delay time will grow expontentially 1, 2, 4, 8, 16, 32..

However, there might be a chance that millions of device are all synchronized. 
A jitter ( i.e. some randomness ) is needed to cancel out the effect.

random(0, 1), random(0, 2), random(0, 4)...

- important: The client will refuse to make any request all together if the user has reached the API's maximum request rate (Rate Limit).

*Luckly AfterShipClient has implemented this feature so you don't have to.*
*/


let defaultSetting = ExponentialBackoff(baseDelayTimeInSeconds: 1, maximumDelayTimeInSeconds: 60)


let result = (0...100).map({ (i) -> Int in
	let attempt = Int(arc4random_uniform(10));
	let delay = defaultSetting.generateSleepTime(attempt);
	return Int(delay);
}).reduce([Int: Int]()) { (result, delay) -> [Int: Int] in
	var newResult = result;
	if let count = result[delay] {
		newResult[delay] = count + 1;
	} else {
		newResult[delay] = 0;
	}
	return newResult;
}

let keys = result.keys.sort();
for key in keys {
	let value = result[key];
	print("\(value) times that the request have to wait for \(key) seconds before performing ")
}
