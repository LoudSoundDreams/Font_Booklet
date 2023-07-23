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
	
	var body: some View {
		List(family.members, id: \.self) { member in
			SampleView(
				label: member,
				memberName: member,
				sampleText: sampleText,
				withBookmark: false)
		}
		.navigationTitle(family.surname)
	}
}
