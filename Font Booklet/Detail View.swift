//
//  Detail View.swift
//  Font Booklet
//
//  Created by h on 2023-07-23.
//

import SwiftUI

struct FamilyDetailView: View {
	let family: Family
	var body: some View {
		List(family.members, id: \.self) { member in
			Text(member)
		}
		.navigationTitle(family.surname)
	}
}
