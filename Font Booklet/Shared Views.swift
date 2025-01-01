//  Created on 2023-07-23.

import SwiftUI
import UIKit

struct SampleRow: View {
	let label: String
	let memberName: String
	let sampleText: String
	let leavesTrailingSpaceForBookmark: Bool
	let accessibilityValueBookmarked: Bool
	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			VStack(alignment: .leading, spacing: .eight) {
				Text(label)
					.font(.caption)
					.foregroundColor(.secondary)
					.accessibilityLabel(
						accessibilityValueBookmarked
						? "\(InterfaceText.bookmarked), \(label)"
						: label
					)
				Text(sampleText == "" ? Pangram.standard : sampleText)
					.font(Font(uiFontCascading))
			}
			Spacer()
			if leavesTrailingSpaceForBookmark {
				BookmarkImage().hidden()
			}
		}
		.accessibilityElement(children: .combine)
		.accessibilityInputLabels([label])
	}
	private var uiFontCascading: UIFont {
		/*
		 Prefer, in order:
		 (1) The specific font this view should showcase.
		 (2) An obviously different font if (1) is missing characters.
		 (3) A default font if (2) is nil.
		 */
		guard let thisFont = UIFont(name: memberName, size: .eight * 4) // (1)
		else { return UIFont.systemFont(ofSize: .zero) } // (3)
		let descriptorCascading = thisFont.fontDescriptor.addingAttributes([
			.cascadeList: [UIFontDescriptor(name: "Courier New", size: .zero)] // (2)
		])
		return UIFont(descriptor: descriptorCascading, size: .zero)
	}
}

struct BookmarkImage: View {
	var body: some View {
		Image(systemName: "bookmark.fill")
			.foregroundStyle(.red)
			.font(.caption)
	}
}
