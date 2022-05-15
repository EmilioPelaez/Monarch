//
//  MonarchExampleApp.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 09/05/22.
//

import SwiftUI
import Monarch

@main
struct MonarchExampleApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.registerProvider(UserClient(), domain: .users)
		}
	}
}

class UserClient: NetworkProvider {
	var baseURL = URL(string: "")!
}
