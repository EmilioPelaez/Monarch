//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public protocol CacheProvider: ResponseHandler {
	func store<R: Request>(_ value: R.ResponseType, for request: R)
	func value<R: Request>(for request: R) async -> R.ResponseType?
}

public extension CacheProvider {
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request {
		guard let value = await value(for: request) else { throw UnhandledRequestError() }
		return value
	}
	
	func handle<R>(_ response: R.ResponseType, for request: R) where R : Request {
		store(response, for: request)
	}
}
