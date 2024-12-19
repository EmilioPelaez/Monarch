//
//  ExampleApp.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 09/05/22.
//

import Monarch
import SwiftUI

@main
struct ExampleApp: App {
	let moviesClient = MoviesClient()
	let imagesClient = ImagesClient()
	
	var body: some Scene {
		WindowGroup {
			MainScreen()
				.register(imagesClient, domain: .images)
				.register(moviesClient, domain: .movies)
		}
	}
}
