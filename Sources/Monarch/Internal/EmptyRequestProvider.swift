//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

struct EmptyRequestProvider: RequestProvider {
	func perform<R>(_ request: R) async throws -> R.ResponseType where R: Request {
		throw UnhandledRequestError(request)
	}
}
