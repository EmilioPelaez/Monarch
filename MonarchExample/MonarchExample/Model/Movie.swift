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
	let releaseDate: String
	let title: String
	let voteAverage: Double
	
	static let example = Movie(id: 0,
							   posterPath: "demo",
							   releaseDate: "June 27, 2008",
							   title: "WALL-E",
							   voteAverage: 0.95)
}
