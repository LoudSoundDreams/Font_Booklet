//  Created on 2023-07-18.

import XCTest
import UIKit
@testable import Font_Booklet

enum KnownFamily: String, CaseIterable {
	case gothicNeo = "Apple SD Gothic Neo" // Contains initialism
	case bodoniOldstyle = "Bodoni 72 Oldstyle" // Face names differ significantly from this
	case courierNew = "Courier New" // Face name of plain style differs from face name of other styles
	case damascus = "Damascus" // No hyphens between face names and style names
	case hiraginoMincho = "Hiragino Mincho ProN" // Style names contain digits
	case stixTwo = "STIX Two Text" // Member names contain underscores
	
	var expectedStyles: [String] {
		switch self {
			case .gothicNeo:
				return [
					"Regular",
					"Thin",
					"UltraLight",
					"Light",
					"Medium",
					"SemiBold",
					"Bold",
				]
			case .bodoniOldstyle:
				return [
					"Book",
					"BookIt",
					"Bold",
				]
			case .courierNew:
				return [
					"",
					"ItalicMT",
					"BoldMT",
					"BoldItalicMT",
				]
			case .damascus:
				// Wrong
				return [
					"",
					"",
					"",
					"",
					"",
				]
			case .hiraginoMincho:
				return [
					"W3",
					"W6",
				]
			case .stixTwo:
				// Wrong
				return [
					"",
					"Italic",
					"",
					"Italic",
					"",
					"Italic",
					"",
					"Italic",
				]
		}
	}
}

final class FontBookletTests: XCTestCase {
	func testGetStylesFromFamily() throws {
		let fetchedFamilies = Set(UIFont.familyNames) // ["Verdana", "Futura"]
		KnownFamily.allCases.forEach { knownFamily in
			XCTAssertTrue(fetchedFamilies.contains(knownFamily.rawValue))
		}
		
		KnownFamily.allCases.forEach { knownFamily in
			// Claim:
			// The tails of the member names in this family are the style names we expect [see above]
			let expectedStyles = knownFamily.expectedStyles
			
			let fetchedMembers = UIFont.fontNames(forFamilyName: knownFamily.rawValue)
			let fetchedStyles = fetchedMembers.map {
				$0.partAfterLastHyphen()
			}
			
			XCTAssertTrue(fetchedStyles.count == expectedStyles.count)
			for (member, expected) in zip(fetchedMembers, expectedStyles) {
				XCTAssertTrue(member.partAfterLastHyphen() == expected)
			}
		}
	}
	
	func testPartAfterLastHyphen() {
		let inputsAndExpectations: [(String, String)] = [
			("", ""),
			("-", ""),
			("a-", ""),
			("--", ""),
			("-b", "b"),
			("c-d-e", "e"),
		]
		inputsAndExpectations.forEach { (input, expectation) in
			XCTAssertEqual(input.partAfterLastHyphen(), expectation)
		}
	}
}

extension String {
	func partAfterLastHyphen() -> String {
		guard
			let indexOfLastHyphen = lastIndex(of: "-"),
			indexOfLastHyphen < index(before: endIndex)
		else {
			return ""
		}
		let result = suffix(from: index(after: indexOfLastHyphen))
		return String(result)
	}
}
