//
//  Created by Emilio Peláez on 6/11/22.
//

import Foundation

/***
 Monarch handles requests using a [Responder Chain](link).
 Monarch objects are create
 */
public struct Monarch: RequestProvider, ResponseHandler {
	let node: Node
	
	public var providers: [RequestProvider] {
		sequence(first: node, next: \.next)
			.lazy
			.compactMap { $0 }
			.map(\.provider)
			.filter { !($0 is EmptyRequestProvider) }
	}
	
	public init() {
		self.init(EmptyRequestProvider())
	}
	
	public func appending(_ provider: RequestProvider, domain: RequestDomain = .any) -> Monarch {
		let next = Node(provider, domain: domain)
		return Monarch(node.provider, domain: node.domain, next: next)
	}
	
	init(_ provider: RequestProvider, domain: RequestDomain = .any, next: Node? = nil) {
		self.node = .init(provider, domain: domain, next: next)
	}
	
	public func perform<R>(_ request: R) async throws -> R.ResponseType where R: Request {
		try await node.perform(request)
	}
	
	public func handle<R>(_ response: R.ResponseType, for request: R) where R: Request {
		node.handle(response, for: request)
	}
}
