//
//  Created by Emilio Peláez on 24/04/22.
//

import Foundation

public protocol ResponseHandler: RequestProvider {
	func handle<R:Request>(_ response: R.ResponseType, for request: R)
}
