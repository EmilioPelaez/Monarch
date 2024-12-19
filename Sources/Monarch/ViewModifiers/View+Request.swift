//
//  Created by Emilio Peláez on 15/05/22.
//

import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
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
