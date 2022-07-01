//
//  Created by Emilio Peláez on 23/04/22.
//

import Monarch

/**
 A very simple example that will store the result of any request in a dictionary.
 
 You probably shouldn't use this on production.
 */
class MemoryCache: CacheProvider {
	var values: [String: Any] = [:]
	
	func store<R>(_ value: R.ResponseType, for request: R) where R : Request {
		values[request.id] = value
	}
	
	func value<R>(for request: R) -> R.ResponseType? where R : Request {
		values[request.id] as? R.ResponseType
	}
}
