//  Created on 2023-07-17.

enum Pangram {
	static let standard = "The quick brown fox jumps over the lazy dog."
	// Not “jumped”.
	
	static func random(otherThan: String) -> String {
		var result = otherThan
		while result == otherThan {
			result = mysteryBag.keys.randomElement()!
		}
		return result
	}
	static func symbolName(ifKnown sample: String) -> String? {
		return mysteryBag[sample]
	}
	private static let mysteryBag: [String: String] = [
		// Alphabetized, except with fallback last.
		
		"Amazingly few discotheques provide jukeboxes.": "die.face.1",
		// Fewest words
		
		"Farmer Jack realized the big yellow quilt was expensive.": "die.face.2",
		// Close to one that aired on “Jeopardy!”
		
		"Pack my box with five dozen liquor jugs.": "die.face.3",
		"Quick-blowing zephyrs vex daft Jim.": "die.face.4",
		
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.": "die.face.5",
		// Includes quotation marks. Keep them curly! https://practicaltypography.com/straight-and-curly-quotes.html
		
		Self.standard: "die.face.6"
	]
}

import UIKit

struct Family {
	let surname: String
	let members: [String]
	static let all: [Self] = {
		var result: [Self] = []
		let surnames = UIFont.familyNames // ["Trebuchet MS", "Verdana"]
		surnames.forEach { surname in
			let members = UIFont.fontNames(forFamilyName: surname) // ["Verdana", "Verdana-Italic", "Verdana-Bold", "Verdana-BoldItalic"]
			result.append(Family(surname: surname, members: members))
		}
		return result
	}()
}
extension Family: Identifiable {
	var id: String { surname }
}
extension Family: Hashable {}
