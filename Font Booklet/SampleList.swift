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

enum Fonts {
	private static let familyAndFaceNames: [[String]] = {
		let families = UIFont.familyNames // ["Verdana", "Futura"]
		return families.map { family in
			return UIFont.fontNames(forFamilyName: family) // ["Verdana", "Verdana-Bold"]
		}
	}()
	static let faceNames: [String] = familyAndFaceNames.flatMap { $0 }
}

final class FontsObservable: ObservableObject {
	private init() {}
	static let shared = FontsObservable()
	
	@Published var bookmarked: Set<String> = []
}

struct SampleList: View {
	@ObservedObject private var fontsObservable: FontsObservable = .shared
	@State private var isEditingSample = false
	@State private var sample = Pangrams.standard
	var body: some View {
		NavigationStack {
			List(Fonts.faceNames, id: \.self) { faceName in
				HStack(alignment: .lastTextBaseline) {
					VStack(alignment: .leading) {
						Text(sample)
							.font(.custom(faceName, size: 32))
						Text(faceName)
							.font(.caption)
							.foregroundColor(.secondary)
					}
					
					Spacer()
					
					ZStack {
						Image(systemName: "bookmark.fill")
							.hidden()
						if fontsObservable.bookmarked.contains(faceName) {
							Image(systemName: "bookmark.fill")
								.foregroundStyle(.red)
						}
					}
				}
				.onTapGesture {
					if fontsObservable.bookmarked.contains(faceName) {
						fontsObservable.bookmarked.remove(faceName)
					} else {
						fontsObservable.bookmarked.insert(faceName)
					}
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
