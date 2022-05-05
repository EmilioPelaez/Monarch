//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation
import SwiftUI

struct RequestProviderNodeKey: EnvironmentKey {
	static let defaultValue: RequestProviderNode = {
		#if DEBUG
		if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
			return RequestProviderNode(RequestPreviewProvider())
		} else {
			return RequestProviderNode(EmptyRequestProvider())
		}
		#else
		return RequestProviderNode(EmptyRequestProvider())
		#endif
	}()
}

extension EnvironmentValues {
	var providerNode: RequestProviderNode {
		get { self[RequestProviderNodeKey.self] }
		set { self[RequestProviderNodeKey.self] = newValue }
	}
}
