//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/// An error received by an HTTP Data Task
public struct HTTPError: Error {
	/// The HTTP Status Code of the request
	public let code: Int
	
	/// Creates an `HTTPError` with a status code
	public init(code: Int) {
		self.code = code
	}
}
