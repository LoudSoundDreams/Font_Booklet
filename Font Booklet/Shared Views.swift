//
//  Shared Views.swift
//  Font Booklet
//
//  Created by h on 2023-07-23.
//

import SwiftUI

struct SampleView: View {
	let label: String
	let familySurname: String
	let memberName: String
	let sampleText: String
	
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
				Text(sampleText)
					.font(.custom(
						memberName,
						size: .eight * 4
					))
			}
			Spacer()
			BookmarkImage(visible: bookmarked.familySurnames.contains(familySurname))
		}
		.swipeActions_toggleBookmarked(familySurname: familySurname, in: bookmarked)
	}
}

private extension View {
	func swipeActions_toggleBookmarked(
		familySurname: String,
		in bookmarked: Bookmarked
	) -> some View {
		swipeActions(edge: .leading) {
			if bookmarked.familySurnames.contains(familySurname) {
				Button {
					bookmarked.familySurnames.remove(familySurname)
				} label: {
					Image(systemName: "bookmark.slash.fill")
				}
				.tint(.red)
			} else {
				Button {
					bookmarked.familySurnames.insert(familySurname)
				} label: {
					Image(systemName: "bookmark.fill")
				}
				.tint(.red)
				// ! Accessibility label
			}
		}
	}
}
