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

public extension View {
	/**
	 Registers a request provider in the view hierarchy.
	 
	 When a provider is registered with this modifier, it will be added to the
	 responder chain of providers. If this provider can't handle a request, the
	 request will be sent to the next provider on the chain.
	 
	 The registered provider will be available to the view that is modified by
	 this modifier, as well as any descendants.
	 */
	func registerProvider(_ provider: RequestProvider, domain: RequestDomain = .any) -> some View {
		modifier(RegisterProviderModifier(provider: provider, domain: domain))
	}
}
