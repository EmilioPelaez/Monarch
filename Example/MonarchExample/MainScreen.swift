//
//  MainScreen.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 28/05/22.
//

import SwiftUI

struct MainScreen: View {
	var body: some View {
		NavigationView {
			MovieList()
				.navigationTitle("Popular Movies")
		}
	}
}

struct MainScreen_Previews: PreviewProvider {
	static var previews: some View {
		MainScreen()
	}
}
