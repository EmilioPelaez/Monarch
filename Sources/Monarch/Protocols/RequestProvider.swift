//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 Request providers receive a request and must return a response of the
 `R.ResponseType` type.
 */
public protocol RequestProvider {
	/**
	 Receives a generic request and returns a value of the type `R.ResponseType`.
	 
	 - Throws: `UnhandledRequestError` when the response can't be handled by this
	 provider
	 */
	func perform<R: Request>(_ request: R) async throws -> R.ResponseType
}
