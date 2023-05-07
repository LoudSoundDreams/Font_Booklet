//
//  SampleList.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

struct SampleList: View {
	private static let familiesAndMembers: [[String]] = {
		let families = UIFont.familyNames // ["Verdana", "Futura"]
		return families.map { family in
			return UIFont.fontNames(forFamilyName: family) // ["Verdana", "Verdana-Bold"]
		}
	}()
	private static let members: [String] = familiesAndMembers.flatMap { $0 }
	
	var body: some View {
		List(Self.members, id: \.self) { fontName in
			VStack(alignment: .leading) {
				Text("The quick brown fox jumps over the lazy dog.")
					.font(.custom(fontName, size: 32))
				Text(fontName)
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
	}
}

struct SampleList_Previews: PreviewProvider {
	static var previews: some View {
		SampleList()
	}
}
