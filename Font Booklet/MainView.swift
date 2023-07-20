//
//  MainView.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

final class Bookmarked: ObservableObject {
	private init() {}
	static let shared = Bookmarked()
	
	@Published var faces: Set<String> = []
}

struct BookmarkImage: View {
	let visible: Bool
	
	var body: some View {
		ZStack {
			Image(systemName: "bookmark.fill")
				.hidden()
			if visible {
				Image(systemName: "bookmark.fill")
					.foregroundStyle(.red)
			}
		}
	}
}

struct TraitCloud: View {
	let uiFont: UIFont
	
	var body: some View {
		HStack(alignment: .top) {
			column(with: FontTrait.allCases.filter { !$0.isClass })
			Spacer()
			column(with: FontTrait.allCases.filter { $0.isClass })
		}
	}
	
	@ViewBuilder
	private func column(with traits: [FontTrait]) -> some View {
		VStack(alignment: .leading) {
			ForEach(traits) { trait in
				let uiFontTraits = uiFont.fontDescriptor.symbolicTraits
				if uiFontTraits.contains(trait.uiFontDescriptorSymbolicTrait) {
					Text(trait.displayName)
						.foregroundStyle(Color.accentColor)
				} else {
					Text(trait.displayName)
						.foregroundStyle(.secondary)
				}
			}
		}
	}
}

private extension View {
	func onTapGesture_ToggleBookmarked(
		name: String,
		in bookmarked: Bookmarked
	) -> some View {
		onTapGesture {
			if bookmarked.faces.contains(name) {
				bookmarked.faces.remove(name)
			} else {
				bookmarked.faces.insert(name)
			}
		}
	}
	
	func swipeActions_ToggleBookmarked(
		name: String,
		in bookmarked: Bookmarked
	) -> some View {
		swipeActions(edge: .leading) {
			if bookmarked.faces.contains(name) {
				Button {
					bookmarked.faces.remove(name)
				} label: {
					Image(systemName: "bookmark.slash.fill")
				}
				.tint(.red)
			} else {
				Button {
					bookmarked.faces.insert(name)
				} label: {
					Image(systemName: "bookmark.fill")
				}
				.tint(.red)
			}
		}
	}
}

struct MemberView: View {
	let name: String
	let sampleText: String
	
	@ObservedObject private var bookmarked: Bookmarked = .shared
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(
				alignment: .leading,
				spacing: .eight
			) {
				Text(name)
					.font(.caption)
					.foregroundColor(.secondary)
				Text(sampleText)
					.font(.custom(
						name,
						size: .eight * 3
					))
			}
			Spacer()
			BookmarkImage(visible: bookmarked.faces.contains(name))
		}
		.contentShape(Rectangle())
		.onTapGesture_ToggleBookmarked(name: name, in: bookmarked)
	}
}

struct MainView: View {
	@ObservedObject private var bookmarked: Bookmarked = .shared
	@State private var sample = Pangrams.standard
	@State private var editingSample = false
	@State private var filteringToBookmarked = false
	var body: some View {
		NavigationStack {
			List(Family.all) { family in
				
				Section(family.surname) {
					ForEach(family.members, id: \.self) { member in
						
						MemberView(
							name: member,
							sampleText: sample)
						.alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
							viewDimensions[.trailing]
						}
					}
				}
			}
			.navigationTitle("Fonts")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button {
						editingSample = true
					} label: {
						Image(systemName: "character.cursor.ibeam")
					}
					.alert(
						"Sample Text",
						isPresented: $editingSample
					) {
						editSampleTextField
						editSamplePangramButton
						editSampleDoneButton
					}
				}
				ToolbarItem(placement: .bottomBar) { Spacer() }
				ToolbarItem(placement: .bottomBar) {
					if filteringToBookmarked {
						filterButton.buttonStyle(.borderedProminent)
					} else {
						filterButton.buttonStyle(.bordered)
					}
				}
			}
		}
	}
	
	private var filterButton: some View {
		Button {
			filteringToBookmarked.toggle()
		} label: {
			Image(systemName: "bookmark")
		}
		.tint(.red)
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

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
	}
}
