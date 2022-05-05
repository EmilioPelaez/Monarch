//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public protocol RequestProvider: AnyObject {
	func perform<R: Request>(_ request: R) async throws -> R.Response
}
