//
//  Created by Emilio Peláez on 24/04/22.
//

import Foundation

/**
 Response handlers receive the response for a request, along with the request,
 and can do anything they want with it, like logging it or caching it.
 */
public protocol ResponseHandler: RequestProvider {
	/// Handle a response for a given request
	func handle<R:Request>(_ response: R.ResponseType, for request: R)
}
