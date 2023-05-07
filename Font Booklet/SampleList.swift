//
//  SampleList.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

struct SampleList: View {
	var body: some View {
		List(UIFont.familyNames, id: \.self) { familyName in
			Text(
				UIFont.fontNames(forFamilyName: familyName)
					.reduce(familyName) { partialResult, fontName in
						partialResult + " & " + fontName
					}
			)
			.font(.custom(familyName, size: 32))
		}
	}
}

struct SampleList_Previews: PreviewProvider {
	static var previews: some View {
		SampleList()
	}
}
