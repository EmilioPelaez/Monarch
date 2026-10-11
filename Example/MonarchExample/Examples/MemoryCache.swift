//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation
import Monarch

/**
 A very simple example that will store the result of any request in a dictionary.
 
 You probably shouldn't use this on production.
 */
final class MemoryCache: CacheProvider, @unchecked Sendable {
	private let lock = NSLock()
	private var values: [String: any Sendable] = [:]
	
	func store<R>(_ value: R.ResponseType, for request: R) where R: Request {
		lock.withLock { values[request.id] = value }
	}
	
	func value<R>(for request: R) -> R.ResponseType? where R: Request {
		lock.withLock { values[request.id] as? R.ResponseType }
	}
}
