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
	let moviesClient = MoviesClient()
	
	var body: some Scene {
		WindowGroup {
			MainScreen()
				.registerProvider(moviesClient, domain: .movies)
		}
	}
}
