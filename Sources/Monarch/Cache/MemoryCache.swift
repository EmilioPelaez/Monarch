//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public class MemoryCache: CacheProvider {
	var values: [String: Any] = [:]
	
	public func store<R>(_ value: R.ResponseType, for request: R) where R : Request {
		values[request.id] = value
	}
	
	public func value<R>(for request: R) -> R.ResponseType? where R : Request {
		values[request.id] as? R.ResponseType
	}
	
}
