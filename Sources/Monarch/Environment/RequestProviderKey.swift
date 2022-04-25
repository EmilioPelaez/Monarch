//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation
import SwiftUI

struct RequestProviderNodeKey: EnvironmentKey {
	static let defaultValue: RequestProviderNode = {
		#if DEBUG
		return RequestProviderNode(RequestPreviewProvider())
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
	
	var requestProvider: RequestProvider {
		providerNode
	}
}
