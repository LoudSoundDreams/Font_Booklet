//
//  SampleList.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

enum Pangrams {
	static let standard = "The quick brown fox jumps over the lazy dog."
	static let mysteryBag: [String] = [
		"Amazingly few discotheques provide jukeboxes.", // Fewest words
		"Brown jars prevented the mixture from freezing quickly.",
		"Farmer Jack realized the big yellow quilt was expensive.", // Close to one that aired on “Jeopardy!”
		"Grumpy wizards make toxic brew for the jovial queen.",
		"Quick-blowing zephyrs vex daft Jim.",
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.", // Includes quotation marks
	]
}

struct SampleList: View {
	private static let familiesAndFaces: [[String]] = {
		let families = UIFont.familyNames // ["Verdana", "Futura"]
		return families.map { family in
			return UIFont.fontNames(forFamilyName: family) // ["Verdana", "Verdana-Bold"]
		}
	}()
	private static let faces: [String] = familiesAndFaces.flatMap { $0 }
	
	@State private var isEditingSample = false
	@State private var sample = Pangrams.standard
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
					.alert(
						"Edit Sample Text",
						isPresented: $isEditingSample
					) {
						editSampleTextField
						
						editSamplePangramButton
						editSampleDoneButton
					}
				}
			}
		}
	}
	
	private var editSampleTextField: some View {
		TextField(
			text: $sample,
			prompt: Text(Pangrams.standard)
		) {
			let _ = UITextField.appearance().clearButtonMode = .whileEditing
		}
	}
	
	private var editSamplePangramButton: some View {
		Button("Pangram!") {
			var newSample = sample
			while newSample == sample {
				newSample = Pangrams.mysteryBag.randomElement()!
			}
			sample = newSample
		}
	}
	
	private var editSampleDoneButton: some View {
		Button("Done") {
			if sample.isEmpty {
				sample = Pangrams.standard
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
