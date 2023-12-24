//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 A protocol defining the requirements for a network request.
 
 Only two properties are strictly required when defining a request:
 `path` and `previewData`. For example:
 
 ```
 struct UsersRequest: Request {
	 var path: String { "users" }
	 var previewData: [User] = []
 }
 ```
 */
public protocol Request {
	associatedtype ResponseType
	
	/// A unique identifier for the request.
	var id: String { get }
	/// The domain to which the request belongs. `any` by default.
	var domain: RequestDomain { get }
	
	/// A response sample used by SwiftUI previews.
	var preview: ResponseType { get }
}

public extension Request {
	var domain: RequestDomain { .any }
}
