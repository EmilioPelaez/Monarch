//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 Request providers receive a request and must return a response of the
 `R.Response` type.
 
 Providers are registered on the view hierarchy using the `.registerProvider()`
 view modifier.
 */
public protocol RequestProvider: AnyObject {
	/**
	 Receives a generic requests and returns a value of the type `R.Response`.
	 
	 If the response cannot be handled, an `UnhandledRequestError`
	 should be thrown.
	 */
	func perform<R: Request>(_ request: R) async throws -> R.Response
}
