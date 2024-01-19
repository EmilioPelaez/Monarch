# Monarch 👑 - WIP

A source-agnostic, request-based, protocol-oriented, resource-fetching library designed for pure-SwiftUI applications.
It's called Monarch because it sits at the top of your view hierarchy.

## Features:

 - Async/Await
 - Resource-Based
 - Protocol-Oriented
 - Source-Agnostic
 - Preview Support
 - Extensible
 - All the buzzwords!

## Description
 
Monarch is a resource-fetching library designed to harness the SwiftUI View Hierarchy to simplify dependency injection.

Resources are described by requests which are handled by providers, which can determine if the resource should be fetched from the network, the app bundle, a cache, or anywhere else.

Providers are registered into the view hierarchy and are called using a responder chain pattern, meaning that if the first provider fails to fetch the resource, the next one will try. This allows to easily separate different functionality (i.e. caching, networking) into modular providers.

## How To Use

### Step 1: Create a Request

`Requests` are one of the basic building blocks of Monarch, they describe a the path to a resrouce. `RemoteRequests` describe the path to a remote resource.

```swift
struct CurrentUserRequest: RemoteRequest {
  var path: String { "users/me" }
  var previewData: User { .example }
}
```

### Step 2: Register a Provider

Providers receive `Requests` and turn them into a resource. They are registered in the view hierarchy and available to all views below.

```swift
struct MonarchApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .register(NetworkClient())
    }
  }
}
```

### Step 3: Perform the Request

The `monarch` Environment Value uses the providers registered in the View Hierarchy to attempt to provide a resource from a `Request`

```swift
struct ContentView: View {
  @Environment(\.monarch) var monarch
  @State var user: User?
  
  var body: some View {
    Text(user?.name ?? "Loading...")
      .task {
        user = try? await monarch.perform(CurrentUserRequest())
      }
  }
}
```

## Implementation Details

### Chaining Providers

Providers are unlikely to be able to handle every single response.  When multiple providers are registered, `Monarch` will call the `perform` method of every provider, in the order they were registered, and will stop once it gets a response.

`Monarch` will only pass a `Request` to a provider if the provider was registered with a compatible `domain` with the `domain` of the `Request`.

```swift
extension RequestDomain {
  static let images = RequestDomain(rawValue: 1 << 0)
}

ContentView()
  .register(ImageCache(), domain: .images)
  .register(ImageClient(), domain: .images)
  .register(NetworkClient(), domain: .any)
```

In this example, any requests in the `images` domain will be received by the `ImageCache`, if no cache value is found, `ImageClient` will fetch the image. Any other requests will be sent directly to `NetworkClient`.

### The RequestProvider Protocol

`RequestProvider` is the protocol that powers most of the other protocols and classes in the library; it defines a single function:

```swift
func perform<R: Request>(_ request: R) async throws -> R.ResponseType
```

Network providers use this function to fetch data from the network, cache providers use it to read values from memory or the disk.
