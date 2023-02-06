//
//  UITextView+GetRowBeginning.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//

import Foundation
import UIKit
extension UITextView {
    func getLocationOfRowBeginingInSelectedRange() -> (Int) {
        for i in stride(from: selectedRange.location - 1, through: 0, by: -1) {
            if (self.attributedText.attributedSubstring(from: NSRange(location: i, length: 1)).string == "\n") {
                return i
            }
        }
        return 0
    }
}
