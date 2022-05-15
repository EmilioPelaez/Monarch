//
//  Created by Emilio Peláez on 24/04/22.
//

import HierarchyResponder
import SwiftUI

@available(iOS 15.0, *)
struct MonarchRequestModifier: ViewModifier {
	@Environment(\.monarch) var monarch
	@Environment(\.reportError) var reportError
	
	let perform: (RequestProvider) async throws -> Void
	
	func body(content: Content) -> some View {
		content
			.task {
				do {
					try await perform(monarch)
				} catch {
					reportError(error)
				}
			}
	}
}
