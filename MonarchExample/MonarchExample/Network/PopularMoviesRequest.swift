//
//  PopularMoviesRequest.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import Foundation
import Monarch

struct PopularMoviesRequest: RemoteRequest {
	var domain: RequestDomain { .movies }
	var path: String { "movie/popular" }
	var preview: [Movie] = Array(repeating: .example, count: 1)
	
	static let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		decoder.dateDecodingStrategy = .formatted(formatter)
		return decoder
	}()
}

extension PopularMoviesRequest {
	struct APIResponse: Decodable {
		let results: [Movie]
	}
	
	func decode(_ data: Data) throws -> [Movie] {
		let response = try Self.decoder.decode(APIResponse.self, from: data)
		return response.results
	}
}
