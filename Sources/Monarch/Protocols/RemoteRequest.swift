//
//  Created by Emilio Peláez on 13/12/23.
//

import Foundation

public protocol RemoteRequest: Request {
	/// The path on the server where this resource will be found.
	var path: String { get }
	/// The HTTP method verb used by this request. `GET` by default.
	var method: HTTPMethod { get }
	/// An optional HTTP body. `nil` by default.
	var body: HTTPBody? { get }
	/// The HTTP query. Empty by default.
	var query: [String: Any] { get }
	
	/// Returns a value of the type `ResponseType` from a `Data` object.
	/// For `Decodable` responses, it uses a `JSONDecoder` by default.
	func decode(_ data: Data) throws -> ResponseType
}

public extension RemoteRequest {
	var id: String { path + method.string + String(describing: query) }
	
	var method: HTTPMethod { .GET }
	var body: HTTPBody? { nil }
	var query: [String: Any] { [:] }
}

public extension RemoteRequest where ResponseType: Decodable {
	func decode(_ data: Data) throws -> ResponseType {
		try JSONDecoder().decode(ResponseType.self, from: data)
	}
}
