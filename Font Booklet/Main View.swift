//  Created on 2023-05-07.

import SwiftUI

@MainActor struct MainView: View {
	@Binding var sample: String
	var body: some View {
		NavigationStack {
			List(visibleFamilies) { family in
				// Make the row tappable and show a chevron on it only if the family has multiple members.
				// It’d be nice to deduplicate this code.
				if family.members.count <= 1 {
					SampleView(
						label: family.surname, memberName: family.members.first!, sampleText: sample,
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
							label: family.surname, memberName: family.members.first!, sampleText: sample,
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
					if filtering {
						ContentUnavailableView(InterfaceText.noBookmarks, systemImage: "bookmark.fill", description: Text(InterfaceText._howToBookmark))
					} else {
						ContentUnavailableView(InterfaceText.noResults, systemImage: "paragraphsign")
					}
				}
			}
			.listStyle(.plain)
			.navigationTitle(InterfaceText.fonts)
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
			.searchPresentationToolbarBehavior(.avoidHidingContent) // As of iOS 17.5.1, if the search field has contents, presenting the “Clear All Bookmarks” action sheet inexplicably opens the keyboard.
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button {
						confirmingClear = true
					} label: {
						Image(systemName: "bookmark.slash")
					}
					.accessibilityLabel(InterfaceText.clearAllBookmarks)
					.disabled(bookmarked.familySurnames.isEmpty)
					.confirmationDialog("", isPresented: $confirmingClear) {
						Button(InterfaceText.clearAllBookmarks, role: .destructive) {
							bookmarked.familySurnames.removeAll()
						}
						Button(InterfaceText.cancel, role: .cancel) {}
					}
				}
				ToolbarItem(placement: .topBarTrailing) { filterButton }
			}
		}
		.toolbar {
			ToolbarItemGroup(placement: .bottomBar) {
				Button { // `Button(_:systemImage:action:)` is simpler, but as of iOS 17.5.1, it inexplicably over-applies Increase Contrast.
					sample = Pangram.random(otherThan: sample)
				} label: {
					Image(systemName: Pangram.symbolName(forText: (
						sample == ""
						? Pangram.standard // So that if the user clears the text, we don’t momentarily show the default symbol.
						: sample
					)))
					.accessibilityLabel(InterfaceText.pangram_exclamationMark)
				}
				.disabled(visibleFamilies.isEmpty)
				Spacer()
				Button {
					editingSample = true
				} label: {
					Image(systemName: "character.cursor.ibeam")
				}
				.accessibilityLabel(InterfaceText.editText)
				.disabled(visibleFamilies.isEmpty)
				.alert(InterfaceText.editText, isPresented: $editingSample) {
					editSampleTextField // As of iOS 17.5.1, if the search field has contents, it inexplicably takes keyboard focus.
					editSampleDoneButton
				}
			}
		}
	}
	private var visibleFamilies: [Family] {
		var result = Family.all
		if filtering {
			result = result.filter { bookmarked.familySurnames.contains($0.surname) }
		}
		if query != "" {
			result = result.filter { $0.surname.lowercased().contains(query.lowercased()) }
		}
		return result
	}
	private let bookmarked: Bookmarked = .shared
	@State private var query: String = ""
	@State private var filtering = false
	@State private var confirmingClear = false
	@State private var editingSample = false
	
	private var filterButton: some View {
		Button {
			filtering.toggle()
		} label: {
			Image(systemName: filtering ? "line.3.horizontal.decrease.circle.fill": "line.3.horizontal.decrease.circle")
		}
		.accessibilityLabel(filtering ? InterfaceText._filterIsOn_axLabel : InterfaceText._filterIsOn_axLabel)
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
	@MainActor func swipeActions_toggleBookmarked(
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

@MainActor @Observable private final class Bookmarked {
	static let shared = Bookmarked()
	private init() {}
	var familySurnames: Set<String> = {
		let allFetchedKeys = Bookmarked.defaults.dictionaryRepresentation().keys
		let keysWithPrefix = allFetchedKeys.filter { key in
			key.hasPrefix(Bookmarked.prefix)
		}
		let result = keysWithPrefix.map { key in
			String(key.dropFirst(Bookmarked.prefix.count))
		}
		return Set(result)
	}() { didSet {
		// Delete or create `UserDefaults` entries accordingly
		let keysToKeep = Set(familySurnames.map { surname in
			"\(Self.prefix)\(surname)"
		})
		
		// Delete
		Self.defaults.dictionaryRepresentation().keys.forEach { existingKey in
			guard
				existingKey.hasPrefix(Self.prefix),
				!keysToKeep.contains(existingKey)
			else { return }
			Self.defaults.removeObject(forKey: existingKey)
		}
		
		// Create
		keysToKeep.forEach { keyToKeep in
			Self.defaults.set(true, forKey: keyToKeep) // Value doesn’t actually matter
		}
	}}
	private static var defaults: UserDefaults { return .standard }
	private static var prefix: String { return DefaultsPrefix.prefix_bookmarkedFamily.rawValue }
}
