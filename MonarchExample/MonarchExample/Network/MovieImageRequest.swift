//
//  MovieImageRequest.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 29/05/22.
//

import Monarch
import SwiftUI

struct MovieImageRequest: Request {
	struct ImageDecodeError: Error {}
	
	var domain: RequestDomain { .images }
	let path: String
	var preview = Image("Poster")
	
	func decode(_ data: Data) throws -> Image {
		guard let image = Image(data: data) else {
			throw ImageDecodeError()
		}
		return image
	}
}
