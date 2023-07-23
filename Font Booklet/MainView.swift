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
	@Published var familySurnames: Set<String> = {
		let allFetchedKeys = Bookmarked.defaults.dictionaryRepresentation().keys
		let keysWithPrefix = allFetchedKeys.filter { key in
			key.hasPrefix(DefaultsPrefix.prefix_bookmarkedFamily.rawValue)
		}
		let result = keysWithPrefix.map { key in
			String(key.dropFirst(DefaultsPrefix.prefix_bookmarkedFamily.rawValue.count))
		}
		return Set(result)
	}()
	{
		didSet {
			// Delete or create `UserDefaults` entries accordingly
			let keysToKeep = Set(familySurnames.map { surname in
				"\(DefaultsPrefix.prefix_bookmarkedFamily.rawValue)\(surname)"
			})
			
			// Delete
			Self.defaults.dictionaryRepresentation().keys.forEach { existingKey in
				guard existingKey.hasPrefix(DefaultsPrefix.prefix_bookmarkedFamily.rawValue) else { return }
				if !keysToKeep.contains(existingKey) {
					Self.defaults.removeObject(forKey: existingKey)
				}
			}
			
			// Create
			keysToKeep.forEach { keyToKeep in
				Self.defaults.set(
					true, // Doesn’t actually matter
					forKey: keyToKeep)
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

private extension View {
	func swipeActions_ToggleBookmarked(
		familySurname: String,
		in bookmarked: Bookmarked
	) -> some View {
		swipeActions(edge: .leading) {
			if bookmarked.familySurnames.contains(familySurname) {
				Button {
					bookmarked.familySurnames.remove(familySurname)
				} label: {
					Image(systemName: "bookmark.slash.fill")
				}
				.tint(.red)
			} else {
				Button {
					bookmarked.familySurnames.insert(familySurname)
				} label: {
					Image(systemName: "bookmark.fill")
				}
				.tint(.red)
				// ! Accessibility label
			}
		}
	}
}

struct SampleView: View {
	let label: String
	let familySurname: String
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
						size: .eight * 4
					))
			}
			Spacer()
			BookmarkImage(visible: bookmarked.familySurnames.contains(familySurname))
		}
		.swipeActions_ToggleBookmarked(familySurname: familySurname, in: bookmarked)
	}
}

struct MainView: View {
	@ObservedObject private var bookmarked: Bookmarked = .shared
	@AppStorage(DefaultsKey.sampleText.rawValue) private var sample: String = Pangrams.standard
	@State private var editingSample = false
	@State private var filteringToBookmarked = false
	private var visibleFamilies: [Family] {
		if filteringToBookmarked {
			return Family.all.filter {
				bookmarked.familySurnames.contains($0.surname)
			}
		} else {
			return Family.all
		}
	}
	@State private var clearBookmarksConfirmationIsPresented = false
	var body: some View {
		NavigationStack {
			List(visibleFamilies) { family in
				NavigationLink(value: family) {
					SampleView(
						label: family.surname,
						familySurname: family.surname,
						memberName: family.members.first!,
						sampleText: sample)
				}
			}
			.navigationDestination(for: Family.self) { family in
				FamilyDetailView(family: family)
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
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						clearBookmarksConfirmationIsPresented = true
					} label: {
						Image(systemName: "bookmark.slash")
					}
					.disabled(bookmarked.familySurnames.isEmpty)
					.confirmationDialog(
						"",
						isPresented: $clearBookmarksConfirmationIsPresented
					) {
						Button(
							"Clear All Bookmarks",
							role: .destructive
						) {
							bookmarked.familySurnames.removeAll()
						}
						Button("Cancel", role: .cancel) {}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar) { filterButton }
				ToolbarItem(placement: .bottomBar) { Spacer() }
				ToolbarItem(placement: .bottomBar) {
					Button {
						editingSample = true
					} label: {
						Image(systemName: "character.cursor.ibeam")
					}
					.disabled(visibleFamilies.isEmpty)
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
