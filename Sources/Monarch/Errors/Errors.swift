//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/// Thrown when a `RequestProvider` is unable to handle a request.
public struct UnhandledRequestError: Error {
	public init() {}
}

/// Thrown when a `NetworkProvider` is unable to build a `URL`.
public struct URLBuilderError: Error {}
