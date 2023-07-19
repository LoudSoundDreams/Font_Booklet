//
//  Resources.swift
//  Font Booklet
//
//  Created by h on 2023-07-17.
//

enum Pangrams {
	static let standard = "The quick brown fox jumps over the lazy dog."
	static let mysteryBag: [String] = [
		"Amazingly few discotheques provide jukeboxes.", // Fewest words
		"Brown jars prevented the mixture from freezing quickly.",
		"Farmer Jack realized the big yellow quilt was expensive.", // Close to one that aired on “Jeopardy!”
		"Grumpy wizards make toxic brew for the jovial queen.",
		"Quick-blowing zephyrs vex daft Jim.",
		"Watch “Jeopardy!”, Alex Trebek’s fun TV quiz game.", // Includes quotation marks
	]
}

import UIKit
enum Fonts {
	static let familyAndFaceNames: [[String]] = {
		let families = UIFont.familyNames // ["Trebuchet MS", "Verdana"]
		return families.map { family in
			let result = UIFont.fontNames(forFamilyName: family) // ["Verdana", "Verdana-Italic", "Verdana-Bold", "Verdana-BoldItalic"]
			print()
			print(family)
			result.forEach {
				print($0)
			}
			return result
		}
	}()
	static let faceNames: [String] = familyAndFaceNames.flatMap { $0 }
}
