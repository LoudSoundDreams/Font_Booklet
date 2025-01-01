//  Created on 2023-05-07.

import SwiftUI

@main struct FontBooklet: App {
	init() {
		// Clean up after ourselves; leave no unused data in persistent storage.
		let defaults = UserDefaults.standard
		let keysToKeep = Set(DefaultsKey.allCases.map { $0.rawValue })
		let prefixesToKeep = DefaultsPrefix.allCases.map { $0.rawValue }
		defaults.dictionaryRepresentation().forEach { (existingKey, _) in
			if keysToKeep.contains(existingKey) { return }
			for prefixToKeep in prefixesToKeep {
				if existingKey.hasPrefix(prefixToKeep) {
					// TO DO: Future OS versions might remove fonts the user bookmarked. Remove those bookmarks.
					return
				}
			}
			defaults.removeObject(forKey: existingKey)
		}
	}
	
	var body: some Scene {
		WindowGroup {
			MainView(sample: $sample)
		}
	}
	@AppStorage(DefaultsKey.sampleText.rawValue) private var sample: String = Pangram.standard
}
