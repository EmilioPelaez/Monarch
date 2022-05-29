//
//  PopularMoviesRequest.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import Foundation
import Monarch

struct PopularMoviesRequest: Request {
	var path: String { "movie/popular" }
	var previewData: [Movie] = Array(repeating: .example, count: 20)
}

extension PopularMoviesRequest {
	struct APIResponse: Decodable {
		let results: [Movie]
	}
	
	func decode(_ data: Data) throws -> [Movie] {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let response = try decoder.decode(APIResponse.self, from: data)
		return response.results
	}
}
