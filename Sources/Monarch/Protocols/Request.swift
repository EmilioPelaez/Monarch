//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 A protocol defining the requirements for a Monarch request.
 
 Only two properties are strictly required when defining a request:
 `id` and `previewData`. For example:
 
 ```
 struct UsersRequest: Request {
	 var id: String { "users" }
	 var previewData: [User] = []
 }
 ```
 */
public protocol Request: Sendable, Identifiable where ID == String {
	/// The type of the response expected from this request
	associatedtype ResponseType: Sendable
	
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
