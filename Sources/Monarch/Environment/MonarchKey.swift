//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation
import SwiftUI

struct MonarchKey: EnvironmentKey {
	static let defaultValue: Monarch = {
		#if DEBUG
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
			return Monarch(RequestPreviewProvider())
		} else {
			return Monarch(EmptyRequestProvider())
		}
		#else
		return Monarch(EmptyRequestProvider())
		#endif
	}()
}
