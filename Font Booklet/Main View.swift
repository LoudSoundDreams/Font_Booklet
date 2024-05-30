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
					let symbolName: String = filteringToBookmarked ? "bookmark.fill" : "paragraphsign"
					let heading: String = filteringToBookmarked ? InterfaceText.noBookmarks : InterfaceText.noResults
					let description: Text? = filteringToBookmarked ? Text(InterfaceText._howToBookmark) : nil
					if #available(iOS 17, *) {
						ContentUnavailableView(heading, systemImage: symbolName, description: description)
					} else {
						VStack {
							Image(systemName: symbolName)
								.foregroundStyle(.secondary)
								.font(.largeTitle)
							Text(heading)
								.font(.title)
							description
								.foregroundStyle(.secondary)
						}
						.multilineTextAlignment(.center)
						.padding()
						.accessibilityElement(children: .combine)
					}
				}
			}
			.listStyle(.plain)
			.navigationTitle(InterfaceText.fonts)
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always)) // I’d like to use `searchPresentationToolbarBehavior(.avoidHidingContent)`, but as of iOS 17.5.1, if the search field has contents, presenting the “Clear All Bookmarks” action sheet inexplicably opens the keyboard.
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
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
					Button(
						InterfaceText.pangram_exclamationMark,
						systemImage: Pangram.symbolName(
							ifKnown: (
								sample == ""
								? Pangram.standard // So that if the user clears the text, we don’t momentarily show the default symbol.
								: sample
							)
						) ?? "dice"
					) {
						sample = Pangram.random(otherThan: sample)
					}
				}
				ToolbarItem(placement: .bottomBar) { Spacer() }
				ToolbarItem(placement: .bottomBar) {
					Button {
						editingSample = true
					} label: {
						Image(systemName: "character.cursor.ibeam")
					}
					.accessibilityLabel(InterfaceText.editText)
					.disabled(visibleFamilies.isEmpty)
					.alert(InterfaceText.editText, isPresented: $editingSample) {
						editSampleTextField
						editSampleDoneButton
					}
				}
			}
		}
	}
	private var visibleFamilies: [Family] {
		var result = Family.all
		if filteringToBookmarked {
			result = result.filter { bookmarked.familySurnames.contains($0.surname) }
		}
		if searchQuery != "" {
			result = result.filter { $0.surname.lowercased().hasPrefix(searchQuery.lowercased()) }
		}
		return result
	}
	@AppStorage(DefaultsKey.sampleText.rawValue) private var sample: String = Pangram.standard
	@ObservedObject private var bookmarked: Bookmarked = .shared
	@State private var searchQuery: String = ""
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
	private var editSampleDoneButton: some View {
		Button(InterfaceText.done) {
			if sample == "" {
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
