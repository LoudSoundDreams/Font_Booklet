//  Created on 2023-07-17.

import UIKit

enum Pangram {
	static let standard = "The quick brown fox jumps over the lazy dog." // Not “jumped”.
	static func random(otherThan: String) -> String {
		var result = otherThan
		while result == otherThan {
			result = bag.keys.randomElement()!
		}
		return result
	}
	static func symbolName(forPangram: String) -> String {
		return bag[forPangram] ?? "dice"
	}
	
	private static let bag: [String: String] = [
		// Alphabetized, except with fallback last.
		
		// Fewest words
		"Amazingly few discotheques provide jukeboxes.": "die.face.1.fill",
		
		// Close to one that aired on “Jeopardy!”
		"Farmer Jack realized the big yellow quilt was expensive.": "die.face.2.fill",
		
		"Pack my box with five dozen liquor jugs.": "die.face.3.fill",
		"Quick-blowing zephyrs vex daft Jim.": "die.face.4.fill",
		
		// Includes quotation marks. Keep them curly! https://practicaltypography.com/straight-and-curly-quotes.html
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.": "die.face.5.fill",
		
		Self.standard: "die.face.6.fill"
	]
}

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
