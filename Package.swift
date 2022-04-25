// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Monarch",
	platforms: [.iOS(.v13), .watchOS(.v6), .macCatalyst(.v14), .macOS(.v12)],
	products: [
		.library(
			name: "Monarch",
			targets: ["Monarch"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "Monarch",
			dependencies: []),
		.testTarget(
			name: "MonarchTests",
			dependencies: ["Monarch"]),
	]
)
