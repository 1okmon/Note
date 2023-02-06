//
//  NoteEditorViewController+TabBarButtonForList.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController {
    func getListToggleBarItem() -> UIBarButtonItem {
        let listActivate = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(toggleListActivation))
        listActivate.setBackgroundImage(UIImage(systemName: "list.bullet"), for: .normal, barMetrics: .default)
        listActivate.tintColor = .black
        return listActivate
    }
    
    @IBAction func toggleListActivation(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        var actionPerfomed = false
        dotListModeIsActive = !dotListModeIsActive
        var selectedRange = firstResponder.selectedRange
        let newLineCharacterLocation = firstResponder.getLocationOfRowBeginingInSelectedRange()
        let lastHighlightedCharacterLocation = selectedRange.location + selectedRange.length
        var attributedString = firstResponder.attributedText
        
        for i in stride(from: lastHighlightedCharacterLocation - 1, through: newLineCharacterLocation, by: -1) {
            if (firstResponder.attributedText.attributedSubstring(from: NSRange(location: i, length: 1)).string == attributedStringForDotInList.string) {
                attributedString = attributedString?.insert(range: NSRange(location: i, length: 1), string: NSAttributedString(""))
                selectedRange.length -= 1
                actionPerfomed = true
                dotListModeIsActive = false
            }
        }
        
        if !actionPerfomed {
            selectedRange.location += 1
            selectedRange.length -= 1
            for i in stride(from: lastHighlightedCharacterLocation - 1, through: newLineCharacterLocation, by: -1) {
                if (firstResponder.attributedText.attributedSubstring(from: NSRange(location: i, length: 1)).string == attributedStringForNewLine.string) {
                    selectedRange.length += 1
                   attributedString = attributedString?.insert(range: NSRange(location: i + 1, length: 0), string: attributedStringForDotInList)
                }
            }
            if newLineCharacterLocation == 0 {
                selectedRange.length += 1
                attributedString = attributedString?.insert(range: NSRange(location: newLineCharacterLocation, length: 0), string: attributedStringForDotInList)
            }
        } else {
            selectedRange.location -= 1
            selectedRange.length += 1
        }
        
        firstResponder.setAttributedString(attributedString: attributedString)
        firstResponder.selectedRange = selectedRange
        updateUndoButtons()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var locationOfRowBeginning = textView.getLocationOfRowBeginingInSelectedRange()
        
        guard textView.attributedText.string.count > 0 else {
            return true
        }
        
        if locationOfRowBeginning == 0 || locationOfRowBeginning == textView.attributedText.string.count - 1 {
            locationOfRowBeginning -= 1
        }

        if (textView.attributedText.attributedSubstring(from: NSRange(location: locationOfRowBeginning + 1, length: 1)).string == attributedStringForDotInList.string) {
            dotListModeIsActive = true
        }
        
        if (textView.attributedText.attributedSubstring(from: NSRange(location: locationOfRowBeginning + 1, length: 1)).string != attributedStringForDotInList.string) {
            dotListModeIsActive = false
        }
        
        guard dotListModeIsActive else {
            return true
        }
        
        if (text == "\n") {
            if (textView.attributedText.attributedSubstring(from: NSRange(location: range.location - 1, length: 1)).string == attributedStringForDotInList.string) {
                    dotListModeIsActive = false
                    return true
            } else {
                let beginning: UITextPosition = textView.beginningOfDocument
                let start: UITextPosition = textView.position(from: beginning, offset: range.location)!
                let end: UITextPosition = textView.position(from: start, offset: range.length)!
                let textRange: UITextRange = textView.textRange(from: start, to: end)!
                
                textView.replace(textRange, withText: (attributedStringForNewLine + attributedStringForDotInList).string)
                let cursor: NSRange = NSMakeRange(range.location + (attributedStringForNewLine.string + attributedStringForDotInList.string).count, 0)
                textView.selectedRange = cursor
            }
            return false
        }
        return true
    }
}
