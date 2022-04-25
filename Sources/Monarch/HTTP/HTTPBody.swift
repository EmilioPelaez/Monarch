//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public struct HTTPBody {
	
	struct StringEncodingError: Error {}
	
	public enum ContentType {
		case textPlain
		case applicationJson
		case custom(String)
	}
	
	public let contentType: ContentType
	public let data: Data
	
}

extension HTTPBody {
	
	public init(text: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) throws {
		guard let data = text.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
			throw StringEncodingError()
		}
		self.contentType = .textPlain
		self.data = data
	}
	
	public init<T: Encodable>(_ object: T, encoder: JSONEncoder = .init()) throws {
		self.contentType = .applicationJson
		self.data = try encoder.encode(object)
	}
	
	public init(json: Any) throws {
		self.contentType = .applicationJson
		self.data = try JSONSerialization.data(withJSONObject: json, options: [])
	}
	
}

extension HTTPBody.ContentType: CustomStringConvertible {
	public var description: String {
		switch self {
		case .textPlain: return "text/plain"
		case .applicationJson: return "application/json"
		case .custom(let string): return string
		}
	}
}

extension HTTPBody.ContentType: Equatable {}

extension HTTPBody: Equatable {}
