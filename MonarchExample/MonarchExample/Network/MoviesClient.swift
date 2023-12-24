//
//  MoviesClient.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import Foundation
import Monarch

class MoviesClient: NetworkProvider {
	var baseURL: URL = {
		guard let url = URL(string: "https://api.themoviedb.org/3/") else {
			fatalError()
		}
		return url
	}()
	
	func buildURL<R: RemoteRequest>(for request: R) throws -> URL {
		let url = baseURL.appendingPathComponent(request.path)
		var items = request.query.map { URLQueryItem(name: $0, value: "\($1)") }
		items.append(URLQueryItem(name: "api_key", value: "14445b52889b7cb98967f7b8a7c9ab2c"))
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw URLBuilderError()
		}
		components.queryItems = items
		guard let finalURL = components.url else {
			throw URLBuilderError()
		}
		return finalURL
	}
}

extension RequestDomain {
	static let movies = RequestDomain(rawValue: 1 << 0)
}
