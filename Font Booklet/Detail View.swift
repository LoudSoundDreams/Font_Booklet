//
//  Detail View.swift
//  Font Booklet
//
//  Created by h on 2023-07-23.
//

import SwiftUI

struct FamilyDetailView: View {
	let family: Family
	let sampleText: String
	
	private var styledMembers: [String] {
		Array(family.members.dropFirst())
	}
	var body: some View {
		List {
			let firstMember = family.members.first!
			Section {
				SampleView(
					label: firstMember,
					memberName: firstMember,
					sampleText: sampleText,
					withBookmark: false)
			}
			Section {
				ForEach(styledMembers, id: \.self) { styledMember in
					SampleView(
						label: styledMember,
						memberName: styledMember,
						sampleText: sampleText,
						withBookmark: false)
				}
			}
		}
		.listStyle(.grouped)
		.navigationTitle(family.surname)
	}
}
