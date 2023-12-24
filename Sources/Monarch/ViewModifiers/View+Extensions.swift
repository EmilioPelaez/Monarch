//
//  Created by Emilio Peláez on 15/05/22.
//

import SwiftUI

@available(iOS 15.0, watchOS 8.0, *)
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
	func request<T: Equatable>(id: T, priority: TaskPriority = .userInitiated, perform: @escaping (Monarch) async throws -> Void) -> some View {
		modifier(MonarchRequestModifier(id: id, priority: priority, perform: perform))
	}
	
	/**
	 Performs a request using the request provider found on the environment when
	 the view appears.
	 
	 Any unhandled errors thrown by the provider will be reported using
	 `HierarchyResponder`.
	 */
	func request(priority: TaskPriority = .userInitiated, perform: @escaping (Monarch) async throws -> Void) -> some View {
		modifier(MonarchRequestModifier(id: 0, priority: priority, perform: perform))
	}
}
