//
//  Shared Views.swift
//  Font Booklet
//
//  Created by h on 2023-07-23.
//

import SwiftUI

struct SampleView: View {
	let label: String
	let memberName: String
	let sampleText: String
	let withBookmark: Bool
	
	@ObservedObject private var bookmarked: Bookmarked = .shared
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(
				alignment: .leading,
				spacing: .eight
			) {
				Text(label)
					.font(.caption)
					.foregroundColor(.secondary)
				Text({ () -> String in
					if sampleText.isEmpty {
						return Pangrams.standard
					}
					return sampleText
				}())
					.font(.custom(
						memberName,
						size: .eight * 4
					))
			}
			Spacer()
			BookmarkImage(visible: withBookmark)
		}
	}
}

struct BookmarkImage: View {
	let visible: Bool
	var body: some View {
		ZStack {
			Image(systemName: "bookmark.fill")
				.hidden()
			if visible {
				Image(systemName: "bookmark.fill")
					.foregroundStyle(.red)
			}
		}
	}
}
