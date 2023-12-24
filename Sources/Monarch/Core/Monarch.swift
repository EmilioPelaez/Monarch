//
//  Created by Emilio Peláez on 6/11/22.
//

import Foundation

/***
 Monarch handles requests using a [Responder Chain](link).
 Monarch objects are create
 */
public class Monarch: RequestProvider, ResponseHandler {
	let provider: RequestProvider
	let domain: RequestDomain
	
	let next: Monarch?
	private(set) weak var previous: Monarch?
	
	public var providers: [RequestProvider] {
		sequence(first: self, next: \.next)
			.lazy
			.compactMap { $0 }
			.map(\.provider)
			.filter { !($0 is EmptyRequestProvider) }
	}
	
	public convenience init() {
		self.init(EmptyRequestProvider())
	}
	
	public func appending(_ provider: RequestProvider, domain: RequestDomain = .any) -> Monarch {
		return Monarch(provider, domain: domain, next: self)
	}
	
	init(_ provider: RequestProvider = EmptyRequestProvider(),
			 domain: RequestDomain = .any,
			 next: Monarch? = nil) {
		self.provider = provider
		self.domain = domain
		self.next = next
		
		next?.previous = self
	}
	
	public func perform<R>(_ request: R) async throws -> R.ResponseType where R: Request {
		do {
			guard domain.contains(request.domain) else { throw UnhandledRequestError(request) }
			let value = try await provider.perform(request)
			previous?.handle(value, for: request)
			return value
		} catch is UnhandledRequestError {
			guard let next = next else { throw UnhandledRequestError(request) }
			return try await next.perform(request)
		} catch {
			throw error
		}
	}
	
	public func handle<R>(_ response: R.ResponseType, for request: R) where R: Request {
		if let handler = provider as? ResponseHandler {
			handler.handle(response, for: request)
		}
		previous?.handle(response, for: request)
	}
}
