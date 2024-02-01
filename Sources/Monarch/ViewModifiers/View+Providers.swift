//
//  Created by Emilio Peláez on 2/2/24.
//

import SwiftUI

public extension View {
	/**
	 Registers a request provider in the view hierarchy.
	 
	 When a provider is registered with this modifier, it will be added to the
	 responder chain of providers. If this provider can't handle a request, the
	 request will be sent to the next provider on the chain.
	 
	 The registered provider will be available to the view that is modified by
	 this modifier, as well as any descendants.
	 */
	func register(_ provider: RequestProvider, domain: RequestDomain = .any) -> some View {
		modifier(RegisterProviderModifier(provider: provider, domain: domain))
	}
	
	/**
	 Registers a closure as a provider in the view hierarchy.
	 
	 When a provider is registered with this modifier, it will be added to the
	 responder chain of providers. If this provider can't handle a request, the
	 request will be sent to the next provider on the chain.
	 
	 The registered provider will be available to the view that is modified by
	 this modifier, as well as any descendants.
	 */
	func provider<R: Request>(for request: R.Type, domain: RequestDomain = .any, handler: @escaping (R) async throws -> R.ResponseType) -> some View {
		modifier(RegisterProviderModifier(provider: GenericProvider(handler: handler), domain: domain))
	}
}
