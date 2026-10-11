//
//  MoviesClient.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import Foundation
import Monarch

final class MoviesClient: NetworkProvider {
	let baseURL: URL = {
		guard let url = URL(string: "https://api.themoviedb.org/3/") else {
			fatalError()
		}
		return url
	}()
	
	func configureURL(_ url: inout URL) throws {
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw URLBuilderError()
		}
		let apiKey = URLQueryItem(name: "api_key", value: "14445b52889b7cb98967f7b8a7c9ab2c")
		components.queryItems = (components.queryItems ?? []) + [apiKey]
		guard let finalURL = components.url else {
			throw URLBuilderError()
		}
		url = finalURL
	}
}

extension RequestDomain {
	static let movies = RequestDomain(rawValue: 1 << 0)
}
