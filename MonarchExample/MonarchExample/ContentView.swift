//
//  ContentView.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 09/05/22.
//

import Monarch
import SwiftUI

struct ContentView: View {
	@State var users: [User] = []
	
	var body: some View {
		Text("Hello, world!")
			.padding()
			.request {
				users = try await $0.perform(UsersRequest())
			}
	}
}

extension RequestDomain {
	static let images = RequestDomain(rawValue: 1 << 1)
}

struct UsersRequest: Request {
	var path: String { "users" }
	var previewData: [User] = []
}

struct User: Codable {
	let name: String
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
