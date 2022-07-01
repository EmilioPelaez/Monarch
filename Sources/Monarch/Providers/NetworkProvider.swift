//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

/**
 A provider protocol that fetches the response from the network using
 `URLSession`.
 
 Implementing a network client using the `NetworkProvider` protocol is usually
 as simple as defining a `baseURL`.
 
 ```
 class NetworkClient: NetworkProvider {
	 var baseURL = URL(string: myURL)!
 }
 ```
 */
public protocol NetworkProvider: RequestProvider {
	/// The url that will be used as a prefix to create the resource URL
	var baseURL: URL { get }
	/// The URLSession to create the URL Data Task. `default` by default.
	var session: URLSession { get }
	
	/// Returns a URL from a given Request. Default implementation provided.
	func buildURL<R: Request>(for request: R) throws -> URL
	/// Builds a URLRequest using the information from a Request. Default implementation provided.
	func buildURLRequest<R: Request>(with url: URL, for request: R) throws -> URLRequest
	/// Validates a (Data, URLResponse) pair. Default implementation provided.
	func validate(data: Data, response: URLResponse) throws
	
	///	Customization point for the final URL.
	func configureURL(_ url: inout URL) throws
	///	Customization point for the final URLRequest
	func configureURLRequest(_ urlRequest: inout URLRequest) throws
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
	
	func configureURL(_ url: inout URL) throws {}
	
	func buildURLRequest<R: Request>(with url: URL, for request: R) throws -> URLRequest {
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.string
		if let body = request.body {
			urlRequest.httpBody = body.data
			urlRequest.addValue(body.contentType.description, forHTTPHeaderField: "Content-Type")
		}
		return urlRequest
	}
	
	func configureURLRequest(_ urlRequest: inout URLRequest) throws {}
	
	func validate(data: Data, response: URLResponse) throws {
		if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
			throw HTTPError(code: response.statusCode)
		}
	}
}

public extension NetworkProvider {
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request {
		var url = try buildURL(for: request)
		try configureURL(&url)
		var urlRequest = try buildURLRequest(with: url, for: request)
		try configureURLRequest(&urlRequest)
		let (data, response) = try await session.data(for: urlRequest)
		try validate(data: data, response: response)
		return try request.decode(data)
	}
}
