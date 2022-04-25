# Monarch 👑 - WIP

A resource based, protocol oriented networking library designed for pure-SwiftUI applications.

### Features:

 - Async/Await
 - Resource Based
 - Protocol Oriented
 - Caching Support
 - Preview Support
 - Extensible
 - All the buzzwords!

### Description

Monarch is a network library designed to harness the SwiftUI View Hierarchy to simplify dependency injection. It's called Monarch because it sits at the top of your hierarchy.

To use Monarch, you register one or multiple request providers at a very high level of your view hierarchy.

```swift
struct MonarchApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .registerProvider(NetworkClient())
    }
  }
}
```

Any views lower in the view hierarchy can read the `requestProvider` environment value and use it to execute a request. Because requests contain a `previewData` value, views can be easily previewed in the Preview Canvas.

```swift
struct ContentView: View {
  @Environment(\.requestProvider) var provider
  @State var user: User?
  
  var body: some View {
    Text(user?.name ?? "Loading...")
      .task {
        do {
          user = try await provider.perform(CurrentUserRequest())
        } catch {
          print("Whoops")
        }
      }
  }
}
```

### Creating a Request

`Requests` are one of the basic building blocks of Monarch. They describe a resource, and can be defined with as few as two values.

```swift
struct CurrentUserRequest: Request {
  var path: String { "users/me" }
  var previewData: User { .example }
}
```

### The RequestProvider Protocol

`RequestProvider` is the protocol that powers most of the other protocols and classes in the library; it defines a single function:

```swift
func perform<R: Request>(_ request: R) async throws -> R.ResponseType
```

Network providers use this function to fetch data from the network, while cache providers use it to read values from memory or the disk.

### Chaining Providers

By specifying the `domain` property of a `Request` you can determine which provider should receive that request.

When multiple providers are registered, Monarch will attempt to call them in the order they were registered.

```swift
extension RequestDomain {
  static let images = RequestDomain(rawValue: 1 << 0)
}

struct MonarchApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .registerProvider(ImageCache(), domain: .images)
        .registerProvider(ImageClient(), domain: .images)
        .registerProvider(NetworkClient(), domain: .any)
    }
  }
}
```

In this example, any requests in the `images` domain will be received by the `ImageCache`, if no cache value is found, `ImageClient` will fetch the image. Any other requests will be sent directly to `NetworkClient`.
