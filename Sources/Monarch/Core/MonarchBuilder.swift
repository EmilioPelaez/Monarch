//
//  Created by Emilio Peláez on 28/12/23.
//

import Foundation

extension Monarch {
	/**
	 `Monarch.Builder` objects are used to create a `Monarch` responder chain
	 outside of the SwiftUI hierarchy.
	 
	 The order in which providers are added using `next` will be the order the
	 responder chain wil use to attempt to handle a request.
	 
	 In the following example, the responder chain will try to handle the request
	 with `imagesClient` first and `moviesClient` second.
	 
	 ```swift
	 let monarch = Monarch.Builder()
		 .next(imagesClient)
		 .next(moviesClient)
		 .build()
	 
	 try await monarch.handle(PopularMoviesRequest())
	 ```
	 */
	public struct Builder {
		
		let blocks: [Block]
		
		/**
		 Creates an empty `Builder`
		 */
		public init() {
			self.blocks = []
		}
		
		init(blocks: [Block]) {
			self.blocks = blocks
		}
		
		/**
		 Adds a `provider` with a specified `domain` to the chain.
		 */
		public func next(_ provider: RequestProvider, domain: RequestDomain = .any) -> Builder {
			Builder(blocks: blocks + [Block(provider: provider, domain: domain)])
		}
		
		/**
		 Crates the `Monarch` responder chain
		 */
		public func build() -> Monarch {
			blocks
				.reversed()
				.reduce(Monarch()) {
					Monarch($1.provider, domain: $1.domain, next: $0)
				}
		}
		
	}
}

extension Monarch.Builder {
	struct Block {
		let provider: RequestProvider
		let domain: RequestDomain
	}
}
