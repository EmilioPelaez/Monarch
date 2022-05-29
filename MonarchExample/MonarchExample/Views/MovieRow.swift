//
//  MovieRow.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import SwiftUI

struct MovieRow: View {
	let movie: Movie
	
	var body: some View {
		HStack {
			Color.gray
				.frame(width: 60, height: 90)
			VStack(alignment: .leading) {
				Text(movie.title)
					.font(.headline)
				Text(movie.releaseDate)
					.font(.caption)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

struct MovieRow_Previews: PreviewProvider {
	static var previews: some View {
		MovieRow(movie: .example)
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
