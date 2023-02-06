//
//  NoteEditorViewController+TextViewDelegate.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == TitleTextView {
            if !TitleTextView.attributedText.string.isEmpty && TitleTextView.text == placeholder {
                TitleTextView.attributedText = NSAttributedString("")
                TitleTextView.textColor = UIColor.black
            }
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoButtons()
    }
}
