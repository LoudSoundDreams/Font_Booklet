//
//  MainView.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

final class FontsObservable: ObservableObject {
	private init() {}
	static let shared = FontsObservable()
	
	@Published var bookmarked: Set<String> = []
}

struct MainView: View {
	@ObservedObject private var fontsObservable: FontsObservable = .shared
	@State private var sample = Pangrams.standard
	@State private var isFullyExpanded = false
	@State private var isEditingSample = false
	@State private var showingBookmarkedOnly = false
	var body: some View {
		NavigationStack {
			let visibleFaces: [String] = showingBookmarkedOnly
			? Fonts.faceNames.filter { fontsObservable.bookmarked.contains($0) }
			: Fonts.faceNames
			
			List(visibleFaces, id: \.self) { faceName in
				
				DisclosureGroup(faceName) {
					
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
				
			}
			.navigationTitle("Fonts")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem {
					Button {
						isFullyExpanded.toggle()
					} label: {
						if isFullyExpanded {
							Image(systemName: "rectangle.compress.vertical")
						} else {
							Image(systemName: "rectangle.expand.vertical")
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .bottomBar) {
					Button {
						isEditingSample = true
					} label: {
						Image(systemName: "character.cursor.ibeam")
					}
					.alert(
						"Sample Text",
						isPresented: $isEditingSample
					) {
						editSampleTextField
						
						editSamplePangramButton
						editSampleDoneButton
					}
				}
				
				ToolbarItem(placement: .bottomBar) {
					Spacer()
				}
				
				ToolbarItem(placement: .bottomBar) {
					if showingBookmarkedOnly {
						filterButton
							.buttonStyle(.borderedProminent)
					} else {
						filterButton
							.buttonStyle(.bordered)
					}
				}
			}
		}
	}
	
	private var filterButton: some View {
		Button {
			showingBookmarkedOnly.toggle()
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
