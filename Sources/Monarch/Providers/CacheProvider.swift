//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 WIP
 */
public protocol CacheProvider: ResponseHandler {
	/// Stores the value for a given request.
	func store<R: Request>(_ value: R.ResponseType, for request: R) async
	/// Attempts to stored value for a given request.
	func value<R: Request>(for request: R) async -> R.ResponseType?
}

public extension CacheProvider {
	func perform<R>(_ request: R) async throws -> R.ResponseType where R: Request {
		guard let value = await value(for: request) else { throw UnhandledRequestError(request) }
		return value
	}
	
	func handle<R>(_ response: R.ResponseType, for request: R) async where R: Request {
		await store(response, for: request)
	}
}
