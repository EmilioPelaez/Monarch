//
//  Movie.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import Foundation

struct Movie: Codable, Identifiable {
	let id: Int
	let posterPath: String
	let releaseDate: Date
	let title: String
	let voteAverage: Double
	
	static let example = Movie(id: 0,
							   posterPath: "demo",
							   releaseDate: .now,
							   title: "Spider-Man: No Way Home",
							   voteAverage: 9.5)
}
