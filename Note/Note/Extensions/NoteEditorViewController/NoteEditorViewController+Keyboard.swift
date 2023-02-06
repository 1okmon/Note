//
//  NoteEditorViewController+Keyboard.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//

import Foundation
import UIKit
extension NoteEditorViewController {
    func subscribeKeyboardNotidication() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unscribeKeyboardNotidication() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if picker.frame.origin.y == view.frame.height - 150 {
                picker.frame.origin.y -= keyboardSize.height - 40
            }
            
            guard let firstResponder = view.window?.firstResponder as? UITextView else {
                return
            }
            
            guard firstResponder == BodyTextView else {
                return
            }
            firstResponder.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let cursorPosition = firstResponder.selectedTextRange?.start else {
                    return
                }
                let offset = firstResponder.frame.origin.y + firstResponder.caretRect(for: cursorPosition).origin.y - (self.view.frame.height - keyboardSize.height - 60 )
                if offset > 0 {
                    firstResponder.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if picker.frame.origin.y != view.frame.height - 150 {
            picker.frame.origin.y = view.frame.height - 150
        }
        
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        firstResponder.contentInset = .zero
        firstResponder.contentOffset = .zero
    }
}
