//
//  NoteEditorViewController+FontAttributes.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController {
    func getBoldToggleBarItem() -> UIBarButtonItem {
        let boldButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(applyBold))
        boldButton.setBackgroundImage(UIImage(systemName: "bold"), for: .normal, barMetrics: .default)
        boldButton.tintColor = .black
        return boldButton
    }
    
    func getItalicToggleBarItem() -> UIBarButtonItem {
        let italicButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(applyItalic))
        italicButton.setBackgroundImage(UIImage(systemName: "italic"), for: .normal, barMetrics: .default)
        italicButton.tintColor = .black
        return italicButton
    }
    
    @IBAction func applyBold(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        highlightedSector = firstResponder.selectedRange
        
        guard highlightedSector.length > 0 else {
            return
        }
        
        let font = firstResponder.font?.bold()
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.font: font as Any])
        firstResponder.selectedRange = highlightedSector
    }
    
    @IBAction func applyItalic(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        highlightedSector = firstResponder.selectedRange
        
        guard highlightedSector.length > 0 else {
            return
        }
        
        let font = firstResponder.font?.italic()
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.font: font as Any])
        firstResponder.selectedRange = highlightedSector
    }
}
