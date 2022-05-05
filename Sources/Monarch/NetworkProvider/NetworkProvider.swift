//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public protocol NetworkProvider: RequestProvider {
	var baseURL: URL { get }
	var session: URLSession { get }
	
	func buildURL<R: Request>(for request: R) throws -> URL
	func buildURLRequest<R: Request>(for request: R) throws -> URLRequest
	func fetch<R: Request>(for request: R) async throws -> (Data, URLResponse)
	func validate(data: Data, response: URLResponse) throws
}

public extension NetworkProvider {
	var session: URLSession { .shared }
}

public extension NetworkProvider {
	func buildURL<R: Request>(for request: R) throws -> URL {
		let url = baseURL.appendingPathComponent(request.path)
		guard !request.query.isEmpty else {
			return url
		}
		let items = request.query.map { URLQueryItem(name: $0, value: "\($1)") }
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw URLBuilderError()
		}
		components.queryItems = items
		guard let finalURL = components.url else {
			throw URLBuilderError()
		}
		return finalURL
	}
	
	func buildURLRequest<R: Request>(for request: R) throws -> URLRequest {
		let url = try buildURL(for: request)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.string
		if let body = request.body {
			urlRequest.httpBody = body.data
			urlRequest.addValue(body.contentType.description, forHTTPHeaderField: "Content-Type")
		}
		return urlRequest
	}
	
	func fetch<R: Request>(for request: R) async throws -> (Data, URLResponse) {
		let urlRequest = try buildURLRequest(for: request)
		let (data, response) = try await session.data(for: urlRequest)
		try validate(data: data, response: response)
		return (data, response)
	}
	
	func validate(data: Data, response: URLResponse) throws {
		if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
			throw HTTPError(code: response.statusCode)
		}
	}
}

public extension NetworkProvider {
	func perform<R>(_ request: R) async throws -> R.Response where R : Request {
		try request.decode(try await fetch(for: request).0)
	}
}
