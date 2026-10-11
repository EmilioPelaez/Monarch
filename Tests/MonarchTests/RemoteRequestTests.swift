@testable import Monarch
import XCTest

final class RemoteRequestTests: XCTestCase {
	func testQueryIsSentInTheURL() throws {
		let request = ItemsRequest(query: ["sort": "name", "page": "2", "id": "abc"])

		let url = try Client().buildURL(for: request)
		let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

		XCTAssertEqual(Set(items), [
			URLQueryItem(name: "sort", value: "name"),
			URLQueryItem(name: "page", value: "2"),
			URLQueryItem(name: "id", value: "abc"),
		])
	}

	func testIdDoesNotDependOnTheOrderOfTheQuery() {
		let names = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var first: [String: String] = [:]
		for name in names {
			first[name] = "1"
		}
		var second = [String: String](minimumCapacity: 200)
		for name in names.reversed() {
			second[name] = "1"
		}

		XCTAssertEqual(ItemsRequest(query: first).id, ItemsRequest(query: second).id)
	}

	func testIdIncludesTheQuery() {
		let first = ItemsRequest(query: ["page": "1"])
		let second = ItemsRequest(query: ["page": "2"])

		XCTAssertNotEqual(first.id, second.id)
		XCTAssertEqual(first.id, #"itemsGET[(key: "page", value: "1")]"#)
	}

	func testDecodableResponsesUseTheRequestDecoder() throws {
		let data = Data(#"{"first_name": "Ada"}"#.utf8)

		XCTAssertEqual(try SnakeCaseRequest().decode(data), User(firstName: "Ada"))
		XCTAssertThrowsError(try DefaultDecoderRequest().decode(data))
	}

	func testClassRequestsUseTheRemoteRequestId() {
		let id = ClassRequest().id

		XCTAssertEqual(id, "itemsGET[]")
		XCTAssertEqual(identifier(of: ClassRequest()), "itemsGET[]")
	}

	func testRequestsWithoutQueryHaveNoQueryItems() throws {
		let request = ItemsRequest(query: [:])

		let url = try Client().buildURL(for: request)

		XCTAssertEqual(url.absoluteString, "https://example.com/items")
	}
}

private struct Client: NetworkProvider {
	var baseURL: URL {
		URL(string: "https://example.com")!
	}
}

private struct ItemsRequest: RemoteRequest {
	let query: [String: String]

	var path: String { "items" }
	var preview: String { "preview" }
	func decode(_: Data) throws -> String { "response" }
}

private struct User: Decodable, Equatable {
	let firstName: String
}

private struct DefaultDecoderRequest: RemoteRequest {
	var path: String { "user" }
	var preview: User { User(firstName: "Preview") }
}

private struct SnakeCaseRequest: RemoteRequest {
	var path: String { "user" }
	var preview: User { User(firstName: "Preview") }

	var decoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
}

private final class ClassRequest: RemoteRequest {
	var path: String { "items" }
	var preview: String { "preview" }
	func decode(_: Data) throws -> String { "response" }
}

private func identifier<T: Identifiable>(of value: T) -> T.ID {
	value.id
}
