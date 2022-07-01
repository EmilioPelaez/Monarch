//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 A protocol defining the requirements for a network request.
 
 Only two properties are strictly required when defining a request:
 `path` and `previewData`. For example:
 
 ```
 struct UsersRequest: Request {
	 var path: String { "users" }
	 var previewData: [User] = []
 }
 ```
 */
public protocol Request {
	associatedtype ResponseType
	associatedtype PackedType
	
	/// A unique identifier for the request. Autogenerated by default.
	var id: String { get }
	/// The domain to which the request belongs. `any` by default.
	var domain: RequestDomain { get }
	
	/// The path on the server where this resource will be found.
	var path: String { get }
	/// The HTTP method verb used by this request. `GET` by default.
	var method: HTTPMethod { get }
	/// An optional HTTP body. `nil` by default.
	var body: HTTPBody? { get }
	/// The HTTP query. Empty by default.
	var query: [String: Any] { get }
	
	/// A response sample used by SwiftUI previews.
	var preview: ResponseType { get }
	
	/// Returns a value of the type `ResponseType` from a `Data` object.
	/// For `Decodable` responses, it uses a `JSONDecoder` by default.
	func decode(_ data: Data) throws -> ResponseType
	
	/// Packs a response into a value of the type `PackedType` for cache storage.
	func pack(_ response: ResponseType) -> PackedType?
	/// Unpacks a `PackedType` value into a response. Used for reading from cache.
	func unpack(_ packed: PackedType) -> ResponseType?
}

public extension Request {
	var id: String { path + method.string + String(describing: query) }
	var domain: RequestDomain { .any }
	
	var method: HTTPMethod { .GET }
	var body: HTTPBody? { nil }
	var query: [String: Any] { [:] }
}

public extension Request where ResponseType: Decodable {
	func decode(_ data: Data) throws -> ResponseType {
		try JSONDecoder().decode(ResponseType.self, from: data)
	}
}

public extension Request where ResponseType == PackedType {
	func pack(_ response: ResponseType) -> PackedType? {
		response
	}
	func unpack(_ packed: PackedType) -> ResponseType? {
		packed
	}
}

public extension Request where ResponseType: Codable, PackedType == Data {
	func pack(_ response: ResponseType) -> PackedType? {
		try? JSONEncoder().encode(response)
	}
	func unpack(_ packed: PackedType) -> ResponseType? {
		try? JSONDecoder().decode(ResponseType.self, from: packed)
	}
}
