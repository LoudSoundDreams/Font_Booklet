//
//  FontBookletApp.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

enum DefaultsKey: String, CaseIterable {
	case sampleText = "SampleText"
}
enum DefaultsPrefix: String, CaseIterable {
	case prefix_bookmarkedFamily = "BookmarkedFamily:"
}

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
