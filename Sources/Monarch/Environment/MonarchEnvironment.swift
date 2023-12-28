//
//  Created by Emilio Peláez on 05/05/22.
//

import SwiftUI

public extension EnvironmentValues {
	/**
	 An environment value that provides access to the first `Monarch` node in the
	 responder chain.
	 */
	var monarch: Monarch {
		get { self[MonarchKey.self] }
		set { self[MonarchKey.self] = newValue }
	}
}
