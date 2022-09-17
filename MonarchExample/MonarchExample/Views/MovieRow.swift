//
//  MovieRow.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import SwiftUI

struct MovieRow: View {
	let movie: Movie
	
	var imageRequest: MovieImageRequest {
		MovieImageRequest(path: movie.posterPath)
	}
	
	var badgeColor: Color {
		switch movie.voteAverage {
		case 0 ..< 5: return .red
		case 5 ..< 7: return .orange
		case 7 ..< 9: return .yellow
		case _: return .green
		}
	}
	
	var body: some View {
		HStack {
			RemoteImage(imageRequest)
				.frame(width: 60, height: 90)
				.clipShape(RoundedRectangle(cornerRadius: 8))
			VStack(alignment: .leading) {
				Text(movie.title)
					.font(.headline)
				Text(movie.releaseDate, format: .dateTime.day().month().year())
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			Text("\(Int(movie.voteAverage * 10))")
				.font(.footnote)
				.bold()
				.foregroundStyle(.white)
				.padding(6)
				.background {
					Circle().foregroundColor(badgeColor)
				}
		}
	}
}

struct MovieRow_Previews: PreviewProvider {
	static var previews: some View {
		MovieRow(movie: .example)
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
