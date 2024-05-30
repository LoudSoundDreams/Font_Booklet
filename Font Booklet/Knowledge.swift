//  Created on 2023-07-17.

enum Pangram {
	static let standard = "The quick brown fox jumps over the lazy dog."
	// Not “jumped”.
	
	static func random(otherThan: String) -> String {
		var result = otherThan
		while result == otherThan {
			result = mysteryBag.randomElement()!
		}
		return result
	}
	private static let mysteryBag: [String] = [
		"Amazingly few discotheques provide jukeboxes.",
		// Fewest words
		
		"Farmer Jack realized the big yellow quilt was expensive.",
		// Close to one that aired on “Jeopardy!”
		
		"Grumpy wizards make toxic brew for the jovial queen.",
		"Pack my box with five dozen liquor jugs.",
		"Quick-blowing zephyrs vex daft Jim.",
		
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.",
		// Includes quotation marks. Keep them curly! https://practicaltypography.com/straight-and-curly-quotes.html
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
