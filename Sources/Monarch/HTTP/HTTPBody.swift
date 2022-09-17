//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 A type describing the body of an HTTP request. The body will always be
 stored as `Data`, but an `HTTPBody` can be initialized in different ways.
 */
public struct HTTPBody {
	public struct StringEncodingError: Error {}
	
	///	The HTTP content type of the body
	public enum ContentType {
		case textPlain
		case applicationJson
		case custom(String)
	}
	
	///	The HTTP content type of the body
	public let contentType: ContentType
	///	The body represented as `Data`
	public let data: Data
}

public extension HTTPBody {
	/// Creates an instance with a content type of `textPlain` and a body of the
	/// encoded text.
	init(text: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) throws {
		guard let data = text.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
			throw StringEncodingError()
		}
		self.contentType = .textPlain
		self.data = data
	}
	
	/// Creates an instance with a content type of `applicationJson` and a body of
	/// the encoded object
	init<T: Encodable>(_ object: T, encoder: JSONEncoder = .init()) throws {
		self.contentType = .applicationJson
		self.data = try encoder.encode(object)
	}
	
	/// Creates an instance with a content type of `applicationJson` and a body of
	/// the serialized json object
	init(json: Any) throws {
		self.contentType = .applicationJson
		self.data = try JSONSerialization.data(withJSONObject: json, options: [])
	}
}

extension HTTPBody.ContentType: CustomStringConvertible {
	public var description: String {
		switch self {
		case .textPlain: return "text/plain"
		case .applicationJson: return "application/json"
		case let .custom(string): return string
		}
	}
}

extension HTTPBody.ContentType: Equatable {}

extension HTTPBody: Equatable {}
