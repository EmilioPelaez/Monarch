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
				.registerProvider(imagesClient, domain: .images)
				.registerProvider(moviesClient, domain: .movies)
		}
	}
}
