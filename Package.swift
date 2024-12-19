// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Monarch",
	platforms: [.iOS(.v14), .macCatalyst(.v14), .tvOS(.v14), .watchOS(.v7), .macOS(.v11), .visionOS(.v1)],
	products: [
		.library(
			name: "Monarch",
			targets: ["Monarch"]
		),
	],
	dependencies: [.package(url: "https://github.com/EmilioPelaez/HierarchyResponder", from: Version(1, 0, 0))],
	targets: [
		.target(
			name: "Monarch",
			dependencies: ["HierarchyResponder"]
		),
		.testTarget(
			name: "MonarchTests",
			dependencies: ["Monarch"]
		),
	]
)
