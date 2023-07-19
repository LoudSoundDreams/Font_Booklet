//
//  Extensions.swift
//  Font Booklet
//
//  Created by h on 2023-07-18.
//

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
