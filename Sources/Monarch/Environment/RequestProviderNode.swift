//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

class RequestProviderNode: RequestProvider, ResponseHandler {
	let next: RequestProviderNode?
	weak var previous: RequestProviderNode?
	
	let provider: RequestProvider
	let domain: RequestDomain
	
	init(_ provider: RequestProvider, domain: RequestDomain = .any, next: RequestProviderNode? = nil) {
		self.provider = provider
		self.domain = domain
		self.next = next
		
		next?.previous = self
	}
	
	func perform<R>(_ request: R) async throws -> R.Response where R : Request {
		do {
            guard domain.contains(request.domain) else { throw UnhandledRequestError() }
			let value = try await provider.perform(request)
			handle(value, for: request)
			return value
		} catch is UnhandledRequestError {
			guard let next = next else { throw UnhandledRequestError() }
			return try await next.perform(request)
		} catch {
			throw error
		}
	}
	
	func handle<R>(_ response: R.Response, for request: R) where R : Request {
		if let handler = provider as? ResponseHandler {
			handler.handle(response, for: request)
		}
		previous?.handle(response, for: request)
	}
}
