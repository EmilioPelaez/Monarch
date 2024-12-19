//
//  Created by Emilio Peláez on 24/04/22.
//

import HierarchyResponder
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct MonarchRequestModifier<T: Equatable>: ViewModifier {
	@Environment(\.monarch) var monarch
	@Environment(\.reportError) var reportError
	
	let id: T
	let priority: TaskPriority
	let perform: (Monarch) async throws -> Void
	
	func body(content: Content) -> some View {
		content
			.task(id: id, priority: priority) {
				do {
					try await perform(monarch)
				} catch {
					reportError(error)
				}
			}
	}
}
