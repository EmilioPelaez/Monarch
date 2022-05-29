//
//  MovieList.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import Monarch
import SwiftUI

struct MovieList: View {
	@State var movies: [Movie] = []
	
	var body: some View {
		List {
			ForEach(movies) { movie in
				MovieRow(movie: movie)
			}
		}
		.request {
			movies = try await $0.perform(PopularMoviesRequest())
		}
	}
}

struct MovieList_Previews: PreviewProvider {
	static var previews: some View {
		MovieList()
	}
}
