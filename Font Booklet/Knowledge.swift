//  Created on 2023-07-17.

import UIKit

enum Pangram {
	static let standard = "The quick brown fox jumps over the lazy dog." // Not “jumped”.
	static func random(otherThan: String) -> String {
		var result = otherThan
		while result == otherThan {
			result = bag.randomElement()!
		}
		return result
	}
	
	private static let bag: [String] = [
		Self.standard,
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.", // Use curly quotation marks. https://practicaltypography.com/straight-and-curly-quotes.html
		"Amazingly few discotheques provide jukeboxes.", // Fewest words.
		"Sympathizing would fix Quaker objectives.", // Also fewest words.
		"TV quiz PhD Mr. Jock bags few lynx.", // Exactly 26 letters.
		"A white fawn jumped quickly over large zinc boxes.",
		"Big July earthquakes confounded zany experimental vows.",
		"Brawny gods flocked up just to quiz and vex him.",
		"Crazy Fredrick bought many very exquisite opal jewels.",
		"Farmer Jack realized the big yellow quilt was expensive.",
		"Few black taxis drive up major roads on quiet hazy nights.",
		"Five or six big jet planes zoomed quickly by the tower.",
		"Fred specialized in the job of making very quaint wax toys.",
		"Gaze at this sentence for just about sixty seconds, then explain what makes it quite different from the average sentence.",
		"Grumpy wizards make a toxic brew for the jovial queen.",
		"Heavy boxes perform quick waltzes and jigs.",
		"Jack quietly moved up front and seized the big ball of wax.",
		"Jack will budget for the most expensive zoology equipment.",
		"Jeb quickly drove a few extra miles on the glazed pavement.",
		"My girl wove six dozen plaid jackets before she quit.",
		"My grandfather picks up quartz and valuable onyx jewels.",
		"Pack my box with five dozen liquor jugs.",
		"Playing quick jazz vibe chords excites my wife.",
		"Quick-blowing zephyrs vex daft Jim.",
		"Quivering jocks fumbled the waxy pizza.",
		"Six pitiful kings vowed to abolish my quite crazy jousts.",
		"The black fox jumped whenever the squirrel gazed suspiciously.",
		"The exodus of squeamish walkers is craved by jazzy pigeons.",
		"The gnomes quickly jinxed the wizard before they vaporized.",
		"The job of waxing chintzy linoleum frequently peeves kids.",
		"The major was fixing lazy Cupid’s broken quiver.",
		"The public was amazed to view the quickness and dexterity of the juggler.",
		"The quick onyx goblin jumps over the lazy dwarf.",
		"We delivered oxygen equipment of the same size back in June.",
		"Zelda might fix the job growth plans very quickly on Monday.",
		"Zombies painfully watched a quickly jinxed graveyard.",
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
