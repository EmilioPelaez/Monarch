//
//  Created by Emilio Peláez on 23/04/22.
//

import SwiftUI

struct RegisterProviderModifier: ViewModifier {
	@Environment(\.monarch) var monarch: Monarch
	
	let provider: RequestProvider
	let domain: RequestDomain
	
	func body(content: Content) -> some View {
		content
			.environment(\.monarch, Monarch(provider, domain: domain, next: monarch.node))
	}
	
}
