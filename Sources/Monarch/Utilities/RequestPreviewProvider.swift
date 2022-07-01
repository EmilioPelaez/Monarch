//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

class RequestPreviewProvider: RequestProvider {
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request {
		request.previewData
	}
}
