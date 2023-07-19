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

struct MainView: View {
	@ObservedObject private var bookmarked: Bookmarked = .shared
	@State private var sample = Pangrams.standard
	@State private var editingSample = false
	@State private var filteringToBookmarked = false
	var body: some View {
		NavigationStack {
			let visibleMembers: [String] = filteringToBookmarked
			? Fonts.members.filter { bookmarked.faces.contains($0) }
			: Fonts.members
			
			List(visibleMembers, id: \.self) { member in
				
				HStack(alignment: .top) {
					VStack(
						alignment: .leading,
						spacing: .eight * 1.5
					) {
						Text(member)
							.font(.caption)
							.foregroundColor(.secondary)
						Text(sample)
							.font(.custom(
								member,
								size: .eight * 4
							))
					}
					
					Spacer()
					
					ZStack {
						Image(systemName: "bookmark.fill")
							.hidden()
						if bookmarked.faces.contains(member) {
							Image(systemName: "bookmark.fill")
								.foregroundStyle(.red)
						}
					}
				}
				.contentShape(Rectangle())
				.alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
					viewDimensions[.trailing]
				}
				.onTapGesture {
					if bookmarked.faces.contains(member) {
						bookmarked.faces.remove(member)
					} else {
						bookmarked.faces.insert(member)
					}
				}
				
			}
			.listStyle(.plain) // As of iOS 16.4, `.inset` seems identical
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
				
				ToolbarItem(placement: .bottomBar) {
					Spacer()
				}
				
				ToolbarItem(placement: .bottomBar) {
					if filteringToBookmarked {
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
