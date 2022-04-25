//
//  Created by Emilio Peláez on 23/04/22.
//

import Foundation

public protocol NetworkProvider: RequestProvider {
	var baseURL: URL { get }
	
	var session: URLSession { get }
	var decoder: JSONDecoder { get }
	
	func buildURL<R: Request>(for request: R) -> URL
	func buildURLRequest<R: Request>(for request: R) -> URLRequest
	func validate(data: Data, response: URLResponse) throws
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension NetworkProvider {
	var session: URLSession { .shared }
	var decoder: JSONDecoder { JSONDecoder() }
}

extension NetworkProvider {
	func buildURL<R: Request>(for request: R) -> URL {
		let url = baseURL.appendingPathComponent(request.path)
		guard !request.query.isEmpty else {
			return url
		}
		let items = request.query.map { URLQueryItem(name: $0, value: "\($1)") }
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			preconditionFailure()
		}
		components.queryItems = items
		guard let finalURL = components.url else {
			preconditionFailure()
		}
		return finalURL
	}
	
	func buildURLRequest<R: Request>(for request: R) -> URLRequest {
		let url = buildURL(for: request)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.string
		if let body = request.body {
			urlRequest.httpBody = body.data
			urlRequest.addValue(body.contentType.description, forHTTPHeaderField: "Content-Type")
		}
		return urlRequest
	}
	
	func validate(data: Data, response: URLResponse) throws {
		if let response = response as? HTTPURLResponse, !(200..<300).contains(response.statusCode) {
			throw HTTPError(code: response.statusCode)
		}
	}
	
	func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
		try decoder.decode(type, from: data)
	}
}

extension NetworkProvider {
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request, R.ResponseType == Void {
		let urlRequest = buildURLRequest(for: request)
		let (data, response) = try await session.data(for: urlRequest)
		try validate(data: data, response: response)
		return ()
	}
	
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request, R.ResponseType: Decodable {
		let urlRequest = buildURLRequest(for: request)
		let (data, response) = try await session.data(for: urlRequest)
		try validate(data: data, response: response)
		return try decode(R.ResponseType.self, from: data)
	}
	
	func perform<R>(_ request: R) async throws -> R.ResponseType where R : Request {
		fatalError("Unsupported ResponseType")
	}
}
