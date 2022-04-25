//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public struct RequestDomain: OptionSet {
	public let rawValue: Int
	
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
	
	public static let any = RequestDomain(rawValue: .max)
}
