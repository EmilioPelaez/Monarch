@testable import Monarch
import XCTest

final class MonarchTests: XCTestCase {
	func testResponseGoesBackThroughTheNodesTheRequestPassed() async throws {
		let log = Log()
		let monarch = Monarch.Builder()
			.next(Handler("first", log))
			.next(Handler("second", log))
			.next(Source())
			.build()

		let response = try await monarch.perform(TestRequest())

		XCTAssertEqual(response, "response")
		XCTAssertEqual(log.handlers, ["second", "first"])
	}

	func testResponseIsNotHandledByTheNodeThatProducedIt() async throws {
		let log = Log()
		let monarch = Monarch.Builder()
			.next(Handler("first", log))
			.next(Handler("responder", log, responds: true))
			.next(Handler("unreached", log))
			.build()

		let response = try await monarch.perform(TestRequest())

		XCTAssertEqual(response, "response")
		XCTAssertEqual(log.handlers, ["first"])
	}

	func testResponseDoesNotReachSiblingBranches() async throws {
		let log = Log()
		let root = Monarch(Source())
		let branchA = Monarch(Handler("a", log), next: root)
		let branchB = Monarch(Handler("b", log), next: root)

		_ = try await branchA.perform(TestRequest())
		XCTAssertEqual(log.handlers, ["a"])

		_ = try await branchB.perform(TestRequest())
		XCTAssertEqual(log.handlers, ["a", "b"])
	}

	func testResponseDoesNotReachNodesBeforeTheOneThatReceivedTheRequest() async throws {
		let log = Log()
		let root = Monarch(Source())
		let child = Monarch(Handler("child", log), next: root)

		_ = try await root.perform(TestRequest())

		XCTAssertEqual(log.handlers, [])
		_ = child
	}

	func testResponseDoesNotReachHandlersOutsideTheRequestDomain() async throws {
		let log = Log()
		let monarch = Monarch.Builder()
			.next(Handler("other", log), domain: .other)
			.next(Handler("any", log))
			.next(Source())
			.build()

		_ = try await monarch.perform(TestRequest())

		XCTAssertEqual(log.handlers, ["any"])
	}
}

private extension RequestDomain {
	static let other = RequestDomain(rawValue: 1 << 0)
}

private struct TestRequest: Request {
	var id: String { "test" }
	var preview: String { "preview" }
}

/// Responds to every request.
private struct Source: RequestProvider {
	func perform<R: Request>(_ request: R) async throws -> R.ResponseType {
		guard let response = "response" as? R.ResponseType else { throw UnhandledRequestError(request) }
		return response
	}
}

/// Records the names of the handlers that receive a response, in order.
private final class Log: @unchecked Sendable {
	private let lock = NSLock()
	private var names: [String] = []

	var handlers: [String] {
		lock.withLock { names }
	}

	func append(_ name: String) {
		lock.withLock { names.append(name) }
	}
}

/// Logs the responses it receives. Passes requests to the next provider unless `responds` is set.
private struct Handler: ResponseHandler {
	let name: String
	let log: Log
	let responds: Bool

	init(_ name: String, _ log: Log, responds: Bool = false) {
		self.name = name
		self.log = log
		self.responds = responds
	}

	func perform<R: Request>(_ request: R) async throws -> R.ResponseType {
		guard responds, let response = "response" as? R.ResponseType else { throw UnhandledRequestError(request) }
		return response
	}

	func handle<R: Request>(_: R.ResponseType, for _: R) {
		log.append(name)
	}
}
