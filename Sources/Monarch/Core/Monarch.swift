//
//  Created by Emilio Peláez on 6/11/22.
//

import Foundation

/**
 A `Monarch` object represents the first node in a monarch [Responder Chain](link).
 
 When a `Request` is supplied using the `perform` method, the `provider` in the
 `Monarch` node will attempt to handle the request and return a response. If
 the `provider` is not able to handle that response, the request will be sent
 to the `next` node on the chain.
 
 If the `Request` reaches the end of the chain without being handled, an
 `UnhandledRequestError` will be thrown.
 
 Once a `RequestProvider` has produced a response, the response is passed to
 the `ResponseHandler` providers of all the nodes the request passed through
 before reaching it, in the reverse order. The provider that produced the
 response does not receive it.
 */
public final class Monarch: RequestProvider {
	/**
	 The `provider` is the object that encapsulates the logic of how to handle a
	 specific kind of Request
	 */
	public let provider: RequestProvider
	/**
	 A `domain` acts as a filter to determine whether or not an attempt should be
	 made to handle a request
	 */
	public let domain: RequestDomain
	
	/**
	 The node that will attempt to handle the request if the current node is not
	 able to.
	 */
	let next: Monarch?
	
	/**
	 A list of all the nodes in the current responder chain in the order they will
	 receive a response supplied to this node
	 */
	public var nodes: [Monarch] {
		sequence(first: self, next: \.next)
			.lazy
			.compactMap { $0 }
	}
	
	/**
	 Internal initializer. To create a `Monarch` responder chain use the SwiftUI
	 view modifiers or a `Monarch.Builder` object.
	 */
	init(_ provider: RequestProvider = EmptyRequestProvider(),
	     domain: RequestDomain = .any,
	     next: Monarch? = nil) {
		self.provider = provider
		self.domain = domain
		self.next = next
	}
	
	public func perform<R>(_ request: R) async throws -> R.ResponseType where R: Request {
		func performNext() async throws -> R.ResponseType where R: Request {
			guard let next = next else { throw UnhandledRequestError(request) }
			return try await next.perform(request)
		}
		
		guard domain.contains(request.domain) else {
			return try await performNext()
		}
		do {
			return try await provider.perform(request)
		} catch is UnhandledRequestError {}
		let value = try await performNext()
		if let handler = provider as? ResponseHandler {
			await handler.handle(value, for: request)
		}
		return value
	}
}

extension Monarch: CustomStringConvertible {
	public var description: String {
		"Monarch Node, domain: \(String(describing: domain)), provider: \(String(describing: provider))"
	}
}
