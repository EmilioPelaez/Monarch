//
//  Created by Emilio Peláez on 13/12/23.
//

import Foundation

/**
 A protocol defining the requirements for a network request designed to be
 consumed by a `NetworkProvider`
 */
public protocol RemoteRequest: Request {
	/// The path on the server where this resource will be found.
	var path: String { get }
	/// The HTTP method verb used by this request. `GET` by default.
	var method: HTTPMethod { get }
	/// An optional HTTP body. `nil` by default.
	var body: HTTPBody? { get }
	/// The URL query. Values are sent as they are, so they should be formatted
	/// the way the server expects them. Empty by default.
	var query: [String: String] { get }
	
	/// The decoder used for `Decodable` responses. A new `JSONDecoder` by default.
	var decoder: JSONDecoder { get }
	
	/// Returns a value of the type `ResponseType` from a `Data` object.
	/// For `Decodable` responses, it uses `decoder` by default.
	func decode(_ data: Data) throws -> ResponseType
}

public extension RemoteRequest {
	var id: String { path + method.string + String(describing: query.sorted(by: <)) }
	
	var method: HTTPMethod { .GET }
	var body: HTTPBody? { nil }
	var decoder: JSONDecoder { JSONDecoder() }
	var query: [String: String] { [:] }
}

public extension RemoteRequest where ResponseType: Decodable {
	func decode(_ data: Data) throws -> ResponseType {
		try decoder.decode(ResponseType.self, from: data)
	}
}
