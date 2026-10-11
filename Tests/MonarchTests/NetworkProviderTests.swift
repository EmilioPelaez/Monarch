@testable import Monarch
import XCTest

final class NetworkProviderTests: XCTestCase {
	func testInterceptedResponseIsUsedInPlaceOfTheNetwork() async throws {
		let client = Client(intercepted: "intercepted")

		let response = try await client.perform(TextRequest())

		XCTAssertEqual(response, "intercepted")
		XCTAssertEqual(client.log.steps, ["intercept"])
	}

	func testInterceptRunsBeforeTheURLIsBuiltAndProcessAfterValidation() async throws {
		let client = Client()

		let response = try await client.perform(TextRequest())

		XCTAssertEqual(response, "hello processed")
		XCTAssertEqual(client.log.steps, ["intercept", "buildURL", "validate", "process hello"])
	}

	func testProcessIsNotCalledWhenValidationFails() async throws {
		let client = Client(isValid: false)

		do {
			_ = try await client.perform(TextRequest())
			XCTFail("The request should have failed validation")
		} catch is ValidationError {}

		XCTAssertEqual(client.log.steps, ["intercept", "buildURL", "validate"])
	}
}

private struct ValidationError: Error {}

private struct TextRequest: RemoteRequest {
	var path: String { "text" }
	var preview: String { "preview" }

	func decode(_ data: Data) throws -> String {
		String(decoding: data, as: UTF8.self)
	}
}

/// Records the steps taken by a client, in order.
private final class Log: @unchecked Sendable {
	private let lock = NSLock()
	private var values: [String] = []

	var steps: [String] {
		lock.withLock { values }
	}

	func append(_ step: String) {
		lock.withLock { values.append(step) }
	}
}

/// Loads a `data:` URL, so the whole pipeline runs without a server.
private struct Client: NetworkProvider {
	let log = Log()
	var intercepted: String?
	var isValid = true

	var baseURL: URL {
		URL(string: "https://example.com")!
	}

	func intercept<R: RemoteRequest>(_: R) async throws -> R.ResponseType? {
		log.append("intercept")
		return intercepted as? R.ResponseType
	}

	func buildURL<R: RemoteRequest>(for _: R) throws -> URL {
		log.append("buildURL")
		return URL(string: "data:text/plain,hello")!
	}

	func validate(data _: Data, response _: URLResponse) throws {
		log.append("validate")
		guard isValid else { throw ValidationError() }
	}

	func process<R: RemoteRequest>(_ data: inout Data, for _: R) async throws {
		log.append("process \(String(decoding: data, as: UTF8.self))")
		data.append(Data(" processed".utf8))
	}
}
