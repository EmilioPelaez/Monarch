//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

class EmptyRequestProvider: RequestProvider {
	func perform<R>(_ request: R) async throws -> R.Response where R : Request {
		throw UnhandledRequestError()
	}
}
