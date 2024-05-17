//  Created on 2023-05-07.

import SwiftUI

@main
struct FontBookletApp: App {
	init() {
		// Clean up after ourselves; leave no unused data in persistent storage.
		let defaults = UserDefaults.standard
		let keysToKeep = Set(DefaultsKey.allCases.map { $0.rawValue })
		let prefixesToKeep = DefaultsPrefix.allCases.map { $0.rawValue }
		defaults.dictionaryRepresentation().forEach { (existingKey, _) in
			if keysToKeep.contains(existingKey) { return }
			for prefixToKeep in prefixesToKeep {
				if existingKey.hasPrefix(prefixToKeep) { return }
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
