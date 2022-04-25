//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public enum HTTPMethod {
	case GET
	case POST
	case PUT
	case PATCH
	case DELETE
	case custom(String)
	
	public var string: String {
		switch self {
		case .GET: return "GET"
		case .POST: return "POST"
		case .PUT: return "PUT"
		case .PATCH: return "PATCH"
		case .DELETE: return "DELETE"
		case .custom(let method): return method
		}
	}
}
