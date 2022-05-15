//
//  Created by Emilio Peláez on 15/05/22.
//

import SwiftUI

@available(iOS 15.0, *)
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
	
	/**
	 Performs a request using the request provider found on the environment when
	 the view appears.
	 
	 Any unhandled errors thrown by the provider will be reported using
	 `HierarchyResponder`.
	 */
	func request(_ perform: @escaping (RequestProvider) async throws -> Void) -> some View {
		modifier(MonarchRequestModifier(perform: perform))
	}
}
