//
//  Image+Data.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 29/05/22.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Image {
	/// Initializes a SwiftUI `Image` from data.
	/// Source: https://gist.github.com/BrentMifsud/dce3fc6a76b8ef519ea7be0a3b050674
	init?(data: Data, scale: CGFloat = 0) {
		#if canImport(UIKit)
		if let uiImage = UIImage(data: data, scale: scale) {
			self.init(uiImage: uiImage)
		} else {
			return nil
		}
		#elseif canImport(AppKit)
		if let nsImage = NSImage(data: data) {
			self.init(nsImage: nsImage)
		} else {
			return nil
		}
		#else
		return nil
		#endif
	}
}
