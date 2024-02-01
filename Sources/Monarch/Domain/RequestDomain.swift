//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 Request Domains are used to determine which provider will receive a given
 request.
 
 To create a domain, extend RequestDomain and define a new static variable. Be
 careful not to use the same value twice.
 
 ```
 extension RequestDomain {
	 static let images = RequestDomain(rawValue: 1 << 1)
 }
 ```
 
 You can then use it when registering a provider.
 
 ```
 ContentView()
	 .registerProvider(ImageClient(), domain: .images)
 ```
 */
public struct RequestDomain: OptionSet {
	public let rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public static let any = RequestDomain(rawValue: .max)
}
