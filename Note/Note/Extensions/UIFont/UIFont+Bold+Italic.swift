//
//  UIFont+Bold+Italic.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension UIFont {
    func bold() -> UIFont {
        applyTraits(traits: [.traitBold], alreadyApplied: isBold)
    }
    
    func italic() -> UIFont {
        print(isItalic)
        return applyTraits(traits: [.traitItalic], alreadyApplied: isItalic)
    }
    
    private func applyTraits(traits:UIFontDescriptor.SymbolicTraits, alreadyApplied: Bool) -> UIFont {
        if alreadyApplied {
            var symTraits = fontDescriptor.symbolicTraits
            symTraits.remove(traits)
            guard let descriptor = fontDescriptor.withSymbolicTraits(symTraits) else {
                return self
            }
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            var symTraits = fontDescriptor.symbolicTraits
            symTraits.insert(traits)
            guard let descriptor = fontDescriptor.withSymbolicTraits(symTraits) else {
                return self
            }
            return UIFont(descriptor: descriptor, size: 0)
        }
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
