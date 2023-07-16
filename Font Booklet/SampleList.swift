//
//  SampleList.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

struct SampleList: View {
	private static let familiesAndFaces: [[String]] = {
		let families = UIFont.familyNames // ["Verdana", "Futura"]
		return families.map { family in
			return UIFont.fontNames(forFamilyName: family) // ["Verdana", "Verdana-Bold"]
		}
	}()
	private static let faces: [String] = familiesAndFaces.flatMap { $0 }
	
	@State private var isEditingPreviewText = false
	@State private var previewText = "preview text"
	var body: some View {
		List(Self.faces, id: \.self) { faceName in
			VStack(alignment: .leading) {
				Text("The quick brown fox jumps over the lazy dog.")
					.font(.custom(faceName, size: 32))
				Text(faceName)
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button {
					isEditingPreviewText = true
				} label: {
					Image(systemName: "character.cursor.ibeam")
				}
			}
		}
		.alert(
			"Edit Preview Text", // !
			isPresented: $isEditingPreviewText,
			presenting: previewText
		) { text in
			Button {
			} label: {
				Text("actions: \(text)")
			}
		} message: { text in
			Text("message: \(text)")
		}
	}
}

struct SampleList_Previews: PreviewProvider {
	static var previews: some View {
		SampleList()
	}
}
