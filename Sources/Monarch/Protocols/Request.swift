//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public protocol Request {
	associatedtype ResponseType
	
	var id: String { get }
	var domain: RequestDomain { get }
	
	var path: String { get }
	var method: HTTPMethod { get }
	var body: HTTPBody? { get }
	var query: [String: Any] { get }
	
	var previewData: ResponseType { get }
}

extension Request {
	var id: String { path + method.string + String(describing: query) }
	var domain: RequestDomain { .any }
	
	var method: HTTPMethod { .GET }
	var body: HTTPBody? { nil }
	var query: [String: Any] { [:] }
}

extension Request where ResponseType == Void {
	var previewData: ResponseType { () }
}
