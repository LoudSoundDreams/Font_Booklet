//  Created on 2024-05-16.

// For consistency throughout the app.

import Foundation

extension CGFloat {
	static let eight: Self = 8
}

enum DefaultsKey: String, CaseIterable {
	case sampleText = "SampleText"
}
enum DefaultsPrefix: String, CaseIterable {
	case prefix_bookmarkedFamily = "BookmarkedFamily:"
}

enum InterfaceText {
	// Include “_” if the string doesn’t match the constant’s name.
	
	static let done = "Done"
	static let cancel = "Cancel"
	
	static let fonts = "Fonts"
	
	static let toggleFilter = "Toggle Filter"
	static let _filterIsOn_axLabel = "Toggle Filter, on"
	static let _filterIsOff_axLabel = "Toggle Filter, off"
	
	static let noBookmarks = "No Bookmarks"
	static let _howToBookmark = "Swipe right on a font to bookmark it."
	static let bookmarked = "Bookmarked"
	static let unbookmark = "Unbookmark"
	static let clearAllBookmarks = "Clear All Bookmarks"
	
	static let noResults = "No Results"
	
	static let editText = "Edit Text"
	static let pangram_exclamationMark = "Pangram!"
}
