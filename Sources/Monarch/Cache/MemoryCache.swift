//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 A very simple example that will store the result of any request in a dictionary.
 
 You probably shouldn't use this on production.
 */
public class MemoryCache: CacheProvider {
	var values: [String: Any] = [:]
	
	public func store<R>(_ value: R.Response, for request: R) where R : Request {
		values[request.id] = value
	}
	
	public func value<R>(for request: R) -> R.Response? where R : Request {
		values[request.id] as? R.Response
	}
	
}
