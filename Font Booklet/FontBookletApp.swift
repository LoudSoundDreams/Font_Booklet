//
//  FontBookletApp.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

enum UserDefaultsKey: String {
	case sampleText = "SampleText"
}

@main
struct FontBookletApp: App {
	var body: some Scene {
		WindowGroup {
			MainView()
		}
	}
}
