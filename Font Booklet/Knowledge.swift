//
//  Knowledge.swift
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

extension Family: Identifiable {
	var id: String { surname }
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

extension FontTrait: Identifiable {
	var id: Self { self }
}
enum FontTrait: CaseIterable {
	// “Traits”
	case italic
	case bold
	case expanded
	case condensed
	case monospace
	case vertical
	case uiOptimized
	case tightLeading
	case looseLeading
	
	// “Classes”
	case mask
	case oldStyleSerifs
	case transitionalSerifs
	case modernSerifs
	case clarendonSerifs
	case slabSerifs
	case freeformSerifs
	case sansSerif
	case ornamentals
	case scripts
	case symbolic
	
	var uiFontDescriptorSymbolicTrait: UIFontDescriptor.SymbolicTraits {
		switch self {
			case .italic:
				return .traitItalic
			case .bold:
				return .traitBold
			case .expanded:
				return .traitExpanded
			case .condensed:
				return .traitCondensed
			case .monospace:
				return .traitMonoSpace
			case .vertical:
				return .traitVertical
			case .uiOptimized:
				return .traitUIOptimized
			case .tightLeading:
				return .traitTightLeading
			case .looseLeading:
				return .traitLooseLeading
			case .mask:
				return .classMask
			case .oldStyleSerifs:
				return .classOldStyleSerifs
			case .transitionalSerifs:
				return .classTransitionalSerifs
			case .modernSerifs:
				return .classModernSerifs
			case .clarendonSerifs:
				return .classClarendonSerifs
			case .slabSerifs:
				return .classSlabSerifs
			case .freeformSerifs:
				return .classFreeformSerifs
			case .sansSerif:
				return .classSansSerif
			case .ornamentals:
				return .classOrnamentals
			case .scripts:
				return .classScripts
			case .symbolic:
				return .classSymbolic
		}
	}
	
	var isClass: Bool {
		switch self {
			case .italic, .bold, .expanded, .condensed, .monospace, .vertical, .uiOptimized, .tightLeading, .looseLeading:
				return false
			case .mask, .oldStyleSerifs, .transitionalSerifs, .modernSerifs, .clarendonSerifs, .slabSerifs, .freeformSerifs, .sansSerif, .ornamentals, .scripts, .symbolic:
				return true
		}
	}
	
	var displayName: String {
		switch self {
			case .italic:
				return "Italic"
			case .bold:
				return "Bold"
			case .expanded:
				return "Expanded"
			case .condensed:
				return "Condensed"
			case .monospace:
				return "Monospace"
			case .vertical:
				return "Vertical"
			case .uiOptimized:
				return "UI-Optimized"
			case .tightLeading:
				return "Tight Leading"
			case .looseLeading:
				return "Loose Leading"
			case .mask:
				return "Mask"
			case .oldStyleSerifs:
				return "Old-Style Serifs"
			case .transitionalSerifs:
				return "Transitional Serifs"
			case .modernSerifs:
				return "Modern Serifs"
			case .clarendonSerifs:
				return "Clarendon Serifs"
			case .slabSerifs:
				return "Slab Serifs"
			case .freeformSerifs:
				return "Freeform Serifs"
			case .sansSerif:
				return "Sans Serif"
			case .ornamentals:
				return "Ornamentals"
			case .scripts:
				return "Scripts"
			case .symbolic:
				return "Symbolic"
		}
	}
}
