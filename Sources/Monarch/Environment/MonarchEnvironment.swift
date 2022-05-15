//
//  Created by Emilio Peláez on 05/05/22.
//

import SwiftUI

public extension EnvironmentValues {
	/**
	 An environment value that provides access to the first `RequestProvider` in
	 the responder chain.
	 */
	var monarch: RequestProvider {
		providerNode
	}
}
