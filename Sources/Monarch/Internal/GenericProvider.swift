//
//  Created by Emilio Peláez on 1/2/24.
//

import Foundation

struct GenericProvider<T: Request>: RequestProvider {
	let handler: (T) async throws -> T.ResponseType
	
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request {
		guard let viableRequest = request as? T else {
			throw UnhandledRequestError(request)
		}
		let response = try await handler(viableRequest)
		guard let viableResponse = response as? R.ResponseType else {
			fatalError("Invalid response type, somehow")
		}
		return viableResponse
	}
}
