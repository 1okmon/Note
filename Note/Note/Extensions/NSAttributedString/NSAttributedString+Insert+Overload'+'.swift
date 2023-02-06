//
//  NSAttributedString+Insert+Overload'+'.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    func insert (range: NSRange, string: NSAttributedString) -> NSAttributedString {
        let rangeOfHead = NSRange(location: 0, length: range.location)
        let rangeOFTail = NSRange(location: range.location + range.length, length: self.string.count - (range.location + range.length))
        let result = self.attributedSubstring(from: rangeOfHead) + string + self.attributedSubstring(from: rangeOFTail)
        return result
    }
}
