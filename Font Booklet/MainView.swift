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
	
	private static let defaults: UserDefaults = .standard
	private static let persistentKeyHead = "BookmarkedMember "
	@Published var members: Set<String> = {
		let allEntries = Bookmarked.defaults.dictionaryRepresentation()
		let entriesWithHead = allEntries.keys.filter { key in
			key.hasPrefix(Bookmarked.persistentKeyHead)
		}
		let bookmarkedMembers = entriesWithHead.map { entryWithHead in
			let member = entryWithHead.dropFirst(Bookmarked.persistentKeyHead.count)
			return String(member)
		}
		return Set(bookmarkedMembers)
	}()
	{
		didSet {
			let currentKeys: [String] = members.map { member in
				"\(Self.persistentKeyHead)\(member)"
			}
			
			Self.defaults.dictionaryRepresentation().forEach { (fetchedKey, _) in
				if fetchedKey.hasPrefix(Self.persistentKeyHead)
					&& !currentKeys.contains(fetchedKey)
				{
					Self.defaults.removeObject(forKey: fetchedKey)
				}
			}
			
			currentKeys.forEach { currentKey in
				Self.defaults.setValue(
					true, // Doesn’t actually matter
					forKey: currentKey)
			}
		}
	}
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
			if bookmarked.members.contains(name) {
				bookmarked.members.remove(name)
			} else {
				bookmarked.members.insert(name)
			}
		}
	}
	
	func swipeActions_ToggleBookmarked(
		name: String,
		in bookmarked: Bookmarked
	) -> some View {
		swipeActions(edge: .leading) {
			if bookmarked.members.contains(name) {
				Button {
					bookmarked.members.remove(name)
				} label: {
					Image(systemName: "bookmark.slash.fill")
				}
				.tint(.red)
			} else {
				Button {
					bookmarked.members.insert(name)
				} label: {
					Image(systemName: "bookmark.fill")
				}
				.tint(.red)
			}
		}
	}
}

struct SampleView: View {
	let label: String
	let memberName: String
	let sampleText: String
	
	@ObservedObject private var bookmarked: Bookmarked = .shared
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(
				alignment: .leading,
				spacing: .eight
			) {
				Text(label)
					.font(.caption)
					.foregroundColor(.secondary)
				Text(sampleText)
					.font(.custom(
						memberName,
						size: .eight * 3
					))
			}
			Spacer()
			BookmarkImage(visible: bookmarked.members.contains(memberName))
		}
		.swipeActions_ToggleBookmarked(name: memberName, in: bookmarked)
	}
}

struct MainView: View {
	@ObservedObject private var bookmarked: Bookmarked = .shared
	@AppStorage("SampleText") private var sample: String = Pangrams.standard
	@State private var editingSample = false
	@State private var filteringToBookmarked = false
	private var visibleFamilies: [Family] {
		guard filteringToBookmarked else {
			return Family.all
		}
		var result: [Family] = []
		Family.all.forEach { family in
			let visibleMembers: [String] = family.members.filter { member in
				bookmarked.members.contains(member)
			}
			guard !visibleMembers.isEmpty else { return }
			result.append(Family(surname: family.surname, members: visibleMembers))
		}
		return result
	}
	var body: some View {
		NavigationStack {
			List(visibleFamilies) { family in
				NavigationLink(value: family) {
					SampleView(
						label: family.surname,
						memberName: family.members.first!,
						sampleText: sample)
					.alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
						viewDimensions[.trailing]
					}
				}
				.navigationDestination(for: Family.self) { family in
					Text(family.surname)
				}
			}
			.overlay {
				if visibleFamilies.isEmpty {
					// Xcode 15: Replace this with `ContentUnavailableView`.
					VStack {
						Image(systemName: "bookmark.fill")
							.foregroundStyle(.secondary)
							.font(.largeTitle)
						Text("No Bookmarks")
							.font(.title)
						Text("Swipe right on a font to bookmark it.")
							.foregroundStyle(.secondary)
					}
					.multilineTextAlignment(.center)
					.padding()
				}
			}
			.listStyle(.plain)
			.navigationTitle("Fonts")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .bottomBar) { filterButton }
				ToolbarItem(placement: .bottomBar) { Spacer() }
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
			}
		}
	}
	
	private var filterButton: some View {
		Button {
			filteringToBookmarked.toggle()
		} label: {
			if filteringToBookmarked {
				Image(systemName: "line.3.horizontal.decrease.circle.fill")
			} else {
				Image(systemName: "line.3.horizontal.decrease.circle")
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

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
	}
}
