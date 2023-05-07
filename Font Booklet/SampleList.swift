//
//  SampleList.swift
//  Font Booklet
//
//  Created by h on 2023-05-07.
//

import SwiftUI

struct SampleList: View {
	private let fontNames: [String] = [
		"Verdana",
		"Futura",
		"Helvetica",
	]
	
	var body: some View {
		List((1..<4)) { number in
			Text("The quick brown fox jumps over the lazy dog.")
				.font(.custom("Verdana", size: 64))
		}
	}
}

struct SampleList_Previews: PreviewProvider {
	static var previews: some View {
		SampleList()
	}
}
