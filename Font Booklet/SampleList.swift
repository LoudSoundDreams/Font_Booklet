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
	
	@State private var isEditingSample = false
	@State private var sample = Self.defaultSample
	private static let defaultSample = "The quick brown fox jumps over the lazy dog."
	private static let pangrams: [String] = [
		"Amazingly few discotheques provide jukeboxes.", // Fewest words
		"Brown jars prevented the mixture from freezing quickly.",
		"Farmer Jack realized the big yellow quilt was expensive.", // Close to one that aired on “Jeopardy!”
		"Grumpy wizards make toxic brews for the jovial queen.",
		"Quick-blowing zephyrs vex daft Jim.",
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.", // Includes quotation marks
	]
	var body: some View {
		NavigationStack {
			List(Self.faces, id: \.self) { faceName in
				VStack(alignment: .leading) {
					Text(sample)
						.font(.custom(faceName, size: 32))
					Text(faceName)
						.font(.caption)
						.foregroundColor(.secondary)
				}
			}
			.navigationTitle("Fonts")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button {
						isEditingSample = true
					} label: {
						Image(systemName: "character.cursor.ibeam")
					}
				}
			}
			.alert(
				"Edit Sample Text",
				isPresented: $isEditingSample,
				presenting: sample
			) { text in
				TextField(
					text: $sample,
					prompt: Text(Self.defaultSample)
				) {
					let _ = UITextField.appearance().clearButtonMode = .whileEditing
				}
				
				editSamplePangramButton
				
				editSampleDoneButton
			}
		}
	}
	
	private var editSamplePangramButton: some View {
		Button("Pangram!") {
			var newSample = sample
			while newSample == sample {
				newSample = Self.pangrams.randomElement()!
			}
			sample = newSample
		}
	}
	
	private var editSampleDoneButton: some View {
		Button("Done") {
			if sample.isEmpty {
				sample = Self.defaultSample
			}
		}
		.keyboardShortcut(.defaultAction)
	}
}

struct SampleList_Previews: PreviewProvider {
	static var previews: some View {
		SampleList()
	}
}
