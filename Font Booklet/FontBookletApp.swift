//
//  FontBookletApp.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

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
	
	static let editSampleText_axLabel = "Edit sample text"
	static let sampleText = "Sample Text"
	static let pangram_exclamationMark = "Pangram!"
}

import SwiftUI

@main
struct FontBookletApp: App {
	init() {
		let defaults = UserDefaults.standard
		let keysToKeep = Set(DefaultsKey.allCases.map { $0.rawValue })
		let prefixesToKeep = DefaultsPrefix.allCases.map { $0.rawValue }
		defaults.dictionaryRepresentation().forEach { (existingKey, _) in
			// Keep the entry only if we’re still using it; otherwise, delete it.
			
			if keysToKeep.contains(existingKey) { return }
			
			for prefixToKeep in prefixesToKeep {
				if existingKey.hasPrefix(prefixToKeep) {
					return
				}
			}
			
			defaults.removeObject(forKey: existingKey)
		}
	}
	
	var body: some Scene {
		WindowGroup {
			MainView()
		}
	}
}
