//
//  ImagesClient.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 29/05/22.
//

import Foundation
import Monarch

class ImagesClient: NetworkProvider {
	var baseURL: URL = {
		guard let url = URL(string: "https://image.tmdb.org/t/p/w500/") else {
			fatalError()
		}
		return url
	}()
}

extension RequestDomain {
	static let images = RequestDomain(rawValue: 1 << 1)
}
