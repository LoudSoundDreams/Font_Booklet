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
	let leavesTrailingSpaceForBookmark: Bool
	
	var body: some View {
		HStack(alignment: .firstTextBaseline) {
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
			if leavesTrailingSpaceForBookmark {
				BookmarkImage().hidden()
			}
		}
		.accessibilityElement(children: .combine)
	}
}

struct BookmarkImage: View {
	var body: some View {
		Image(systemName: "bookmark.fill")
			.foregroundStyle(.red)
			.font(.caption)
	}
}
