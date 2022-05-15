//
//  Created by Emilio Peláez on 23/04/22.
//

import SwiftUI

struct RegisterProviderModifier: ViewModifier {
	@Environment(\.providerNode) var providerNode: RequestProviderNode
	
	let provider: RequestProvider
	let domain: RequestDomain
	
	func body(content: Content) -> some View {
		content
			.environment(\.providerNode, RequestProviderNode(provider, domain: domain, next: providerNode))
	}
	
}
