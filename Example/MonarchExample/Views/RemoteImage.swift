//
//  RemoteImage.swift
//  MonarchExample
//
//  Created by Emilio Peláez on 29/05/22.
//

import Monarch
import SwiftUI

enum RemoteImagePhase {
	case loading
	case loaded(Image)
	case failed(Error)
}

struct ImageDecodeError: Error {}

struct RemoteImage<ImageRequest: Request, Content: View, Placeholder: View, Failure: View>: View {
	@Environment(\.monarch) var monarch
	@State var phase: RemoteImagePhase = .loading
	
	let request: ImageRequest
	let decoder: (ImageRequest.ResponseType) throws -> Image
	let content: (Image) -> Content
	let placeholder: () -> Placeholder
	let failure: (Error) -> Failure
	
	private init(_ request: ImageRequest,
	             decoder: @escaping (ImageRequest.ResponseType) throws -> Image,
	             @ViewBuilder content: @escaping (Image) -> Content,
	             @ViewBuilder placeholder: @escaping () -> Placeholder,
	             @ViewBuilder failure: @escaping (Error) -> Failure) {
		self.request = request
		self.decoder = decoder
		self.content = content
		self.placeholder = placeholder
		self.failure = failure
	}
	
	var body: some View {
		Group {
			switch phase {
			case .loading:
				placeholder()
			case let .loaded(image):
				content(image)
			case let .failed(error):
				failure(error)
			}
		}
		.request(id: request.id) {
			do {
				let response = try await $0.perform(request)
				let image = try decoder(response)
				phase = .loaded(image)
			} catch {
				phase = .failed(error)
			}
		}
	}
}

extension RemoteImage {
	init(_ request: ImageRequest,
	     @ViewBuilder content: @escaping (Image) -> Content,
	     @ViewBuilder placeholder: @escaping () -> Placeholder,
	     @ViewBuilder failure: @escaping (Error) -> Failure)
		where ImageRequest.ResponseType == Image {
		self.request = request
		self.decoder = { $0 }
		self.content = content
		self.placeholder = placeholder
		self.failure = failure
	}
	
	init(_ request: ImageRequest,
	     @ViewBuilder content: @escaping (Image) -> Content,
	     @ViewBuilder placeholder: @escaping () -> Placeholder)
		where ImageRequest.ResponseType == Image, Failure == Placeholder {
		self.request = request
		self.decoder = { $0 }
		self.content = content
		self.placeholder = placeholder
		self.failure = { _ in placeholder() }
	}
	
	init(_ request: ImageRequest,
	     @ViewBuilder placeholder: @escaping () -> Placeholder)
		where ImageRequest.ResponseType == Image, Content == Image, Failure == Placeholder {
		self.request = request
		self.decoder = { $0 }
		self.content = { $0.resizable() }
		self.placeholder = placeholder
		self.failure = { _ in placeholder() }
	}
	
	init(_ request: ImageRequest)
		where ImageRequest.ResponseType == Image, Content == Image, Placeholder == Color, Failure == Placeholder {
		self.request = request
		self.decoder = { $0 }
		self.content = { $0.resizable() }
		self.placeholder = { .gray }
		self.failure = { _ in .gray }
	}
	
	init(_ request: ImageRequest,
	     @ViewBuilder content: @escaping (Image) -> Content,
	     @ViewBuilder placeholder: @escaping () -> Placeholder,
	     @ViewBuilder failure: @escaping (Error) -> Failure)
		where ImageRequest.ResponseType == Data {
		self.request = request
		self.decoder = {
			guard let image = Image(data: $0) else { throw ImageDecodeError() }
			return image
		}
		self.content = content
		self.placeholder = placeholder
		self.failure = failure
	}
	
	init(_ request: ImageRequest,
	     @ViewBuilder content: @escaping (Image) -> Content,
	     @ViewBuilder placeholder: @escaping () -> Placeholder)
		where ImageRequest.ResponseType == Data, Failure == Placeholder {
		self.request = request
		self.decoder = {
			guard let image = Image(data: $0) else { throw ImageDecodeError() }
			return image
		}
		self.content = content
		self.placeholder = placeholder
		self.failure = { _ in placeholder() }
	}
	
	init(_ request: ImageRequest,
	     @ViewBuilder placeholder: @escaping () -> Placeholder)
		where ImageRequest.ResponseType == Data, Content == Image, Failure == Placeholder {
		self.request = request
		self.decoder = {
			guard let image = Image(data: $0) else { throw ImageDecodeError() }
			return image
		}
		self.content = { $0.resizable() }
		self.placeholder = placeholder
		self.failure = { _ in placeholder() }
	}
	
	init(_ request: ImageRequest)
		where ImageRequest.ResponseType == Data, Content == Image, Placeholder == Color, Failure == Placeholder {
		self.request = request
		self.decoder = {
			guard let image = Image(data: $0) else { throw ImageDecodeError() }
			return image
		}
		self.content = { $0.resizable() }
		self.placeholder = { .gray }
		self.failure = { _ in .gray }
	}
}
