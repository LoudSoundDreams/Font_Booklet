//  Created on 2023-05-07.

import SwiftUI

struct MainView: View {
	var body: some View {
		NavigationStack {
			List(visibleFamilies) { family in
				// Make the row tappable and show a chevron on it only if the family has multiple members.
				// It’d be nice to deduplicate this code.
				if family.members.count <= 1 {
					SampleView(
						label: family.surname,
						memberName: family.members.first!,
						sampleText: sample,
						leavesTrailingSpaceForBookmark: true,
						accessibilityValueBookmarked: bookmarked.familySurnames.contains(family.surname))
					.swipeActions_toggleBookmarked(familySurname: family.surname, in: bookmarked)
					.overlay(alignment: .topTrailing) {
						if bookmarked.familySurnames.contains(family.surname) {
							BookmarkImage()
						}
					}
					.accessibilityElement(children: .combine)
				} else {
					NavigationLink(value: family) {
						SampleView(
							label: family.surname,
							memberName: family.members.first!,
							sampleText: sample,
							leavesTrailingSpaceForBookmark: false,
							accessibilityValueBookmarked: bookmarked.familySurnames.contains(family.surname))
						.swipeActions_toggleBookmarked(familySurname: family.surname, in: bookmarked)
					}
					.overlay(alignment: .topTrailing) {
						if bookmarked.familySurnames.contains(family.surname) {
							BookmarkImage().accessibilityHidden(true)
						}
					}
					.accessibilityElement(children: .combine)
				}
			}
			.navigationDestination(for: Family.self) { family in
				FamilyDetailView(family: family, sampleText: sample)
			}
			.overlay {
				if visibleFamilies.isEmpty {
					// Xcode 15: Replace this with `ContentUnavailableView`.
					VStack {
						Image(systemName: "bookmark.fill")
							.foregroundStyle(.secondary)
							.font(.largeTitle)
						Text(InterfaceText.noBookmarks)
							.font(.title)
						Text(InterfaceText._howToBookmark)
							.foregroundStyle(.secondary)
					}
					.multilineTextAlignment(.center)
					.padding()
					.accessibilityElement(children: .combine)
				}
			}
			.listStyle(.plain)
			.navigationTitle(InterfaceText.fonts)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						clearBookmarksConfirmationIsPresented = true
					} label: {
						Image(systemName: "bookmark.slash")
					}
					.accessibilityLabel(InterfaceText.clearAllBookmarks)
					.disabled(bookmarked.familySurnames.isEmpty)
					.confirmationDialog("", isPresented: $clearBookmarksConfirmationIsPresented) {
						Button(InterfaceText.clearAllBookmarks, role: .destructive) {
							bookmarked.familySurnames.removeAll()
						}
						Button(InterfaceText.cancel, role: .cancel) {}
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
					.accessibilityLabel(InterfaceText.editSampleText_axLabel)
					.disabled(visibleFamilies.isEmpty)
					.alert(InterfaceText.sampleText, isPresented: $editingSample) {
						editSampleTextField
						editSamplePangramButton
						editSampleDoneButton
					}
				}
			}
		}
	}
	private var visibleFamilies: [Family] {
		if filteringToBookmarked {
			return Family.all.filter { bookmarked.familySurnames.contains($0.surname) }
		}
		return Family.all
	}
	@AppStorage(DefaultsKey.sampleText.rawValue) private var sample: String = Pangram.standard
	@ObservedObject private var bookmarked: Bookmarked = .shared
	@State private var filteringToBookmarked = false
	@State private var clearBookmarksConfirmationIsPresented = false
	@State private var editingSample = false
	
	private var filterButton: some View {
		Button {
			filteringToBookmarked.toggle()
		} label: {
			Image(systemName: filteringToBookmarked ? "line.3.horizontal.decrease.circle.fill": "line.3.horizontal.decrease.circle")
		}
		.accessibilityLabel(filteringToBookmarked ? InterfaceText._filterIsOn_axLabel : InterfaceText._filterIsOn_axLabel)
		.accessibilityInputLabels([InterfaceText.toggleFilter])
	}
	
	private var editSampleTextField: some View {
		TextField(text: $sample, prompt: Text(Pangram.standard)) {
			let _ = UITextField.appearance().clearButtonMode = .whileEditing
		}
	}
	private var editSamplePangramButton: some View {
		Button(InterfaceText.pangram_exclamationMark) {
			var newSample = sample
			while newSample == sample {
				newSample = Pangram.mysteryBag.randomElement()!
			}
			sample = newSample
		}
	}
	private var editSampleDoneButton: some View {
		Button(InterfaceText.done) {
			if sample.isEmpty {
				sample = Pangram.standard
			}
		}.keyboardShortcut(.defaultAction)
	}
}

private extension View {
	func swipeActions_toggleBookmarked(
		familySurname: String,
		in bookmarked: Bookmarked
	) -> some View {
		swipeActions(edge: .leading) {
			if bookmarked.familySurnames.contains(familySurname) {
				Button {
					bookmarked.familySurnames.remove(familySurname)
				} label: {
					Image(systemName: "bookmark.slash.fill").accessibilityLabel(InterfaceText.unbookmark)
				}.tint(.red)
			} else {
				Button {
					bookmarked.familySurnames.insert(familySurname)
				} label: {
					Image(systemName: "bookmark.fill")
				}.tint(.red)
			}
		}
	}
}

final class Bookmarked: ObservableObject {
	static let shared = Bookmarked()
	private init() {}
	@Published var familySurnames: Set<String> = {
		let allFetchedKeys = Bookmarked.defaults.dictionaryRepresentation().keys
		let keysWithPrefix = allFetchedKeys.filter { key in
			key.hasPrefix(DefaultsPrefix.prefix_bookmarkedFamily.rawValue)
		}
		let result = keysWithPrefix.map { key in
			String(key.dropFirst(DefaultsPrefix.prefix_bookmarkedFamily.rawValue.count))
		}
		return Set(result)
	}() {
		didSet {
			// Delete or create `UserDefaults` entries accordingly
			let keysToKeep = Set(familySurnames.map { surname in
				"\(DefaultsPrefix.prefix_bookmarkedFamily.rawValue)\(surname)"
			})
			
			// Delete
			Self.defaults.dictionaryRepresentation().keys.forEach { existingKey in
				guard
					existingKey.hasPrefix(DefaultsPrefix.prefix_bookmarkedFamily.rawValue),
					!keysToKeep.contains(existingKey)
				else { return }
				Self.defaults.removeObject(forKey: existingKey)
			}
			
			// Create
			keysToKeep.forEach { keyToKeep in
				Self.defaults.set(true, forKey: keyToKeep) // Value doesn’t actually matter
			}
		}
	}
	private static let defaults: UserDefaults = .standard
}
