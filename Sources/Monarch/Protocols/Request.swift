//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public protocol Request {
	associatedtype Response
	associatedtype Packed
	
	var id: String { get }
	var domain: RequestDomain { get }
	
	var path: String { get }
	var method: HTTPMethod { get }
	var body: HTTPBody? { get }
	var query: [String: Any] { get }
	
	var previewData: Response { get }
	
	func decode(_ data: Data) throws -> Response
	
	func pack(_ response: Response) -> Packed?
	func unpack(_ packed: Packed) -> Response?
}

public extension Request {
	var id: String { path + method.string + String(describing: query) }
	var domain: RequestDomain { .any }
	
	var method: HTTPMethod { .GET }
	var body: HTTPBody? { nil }
	var query: [String: Any] { [:] }
}

public extension Request where Response: Decodable {
	func decode(_ data: Data) throws -> Response {
		try JSONDecoder().decode(Response.self, from: data)
	}
}

public extension Request where Response == Packed {
	func pack(_ response: Response) -> Packed? {
		response
	}
	func unpack(_ packed: Packed) -> Response? {
		packed
	}
}

public extension Request where Response: Codable, Packed == Data {
	func pack(_ response: Response) -> Packed? {
		try? JSONEncoder().encode(response)
	}
	func unpack(_ packed: Packed) -> Response? {
		try? JSONDecoder().decode(Response.self, from: packed)
	}
}
