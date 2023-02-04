//
//  UITextViewWithStack.swift
//  Note
//
//  Created by 1okmon on 04.02.2023.
//

import UIKit

//class UITextViewWithStack: UITextView {
//    var stackForUndo = Stack()
//    var stackForRedo = Stack()
//    
//    func textViewDidChange(_ textView: UITextView) {
//        setAttributeText(text: textView.attributedText)
//    }
//    
//    func setAttributeText(text: NSAttributedString?) {
//        stackForUndo.push(self.attributedText)
//        stackForRedo.clean()
//        self.attributedText = text
//        print(isAvailibleForUndo())
//        print(isAvailibleForRedo())
//        
//        self.undoManager?.redo()
//    }
//    
//    func redo() {
//        if isAvailibleForRedo() {
//            guard let element = stackForRedo.pop() else {
//                return
//            }
//            stackForUndo.push(self.attributedText)
//            self.attributedText = element
//        }
//    }
//    
//    func undo() {
//        if isAvailibleForUndo() {
//            guard let element = stackForUndo.pop() else {
//                return
//            }
//            stackForRedo.push(self.attributedText)
//            self.attributedText = element
//        }
//    }
//    
//    func isAvailibleForRedo() -> Bool {
//        !stackForRedo.isEmpty()
//    }
//    
//    func isAvailibleForUndo() -> Bool {
//        !stackForUndo.isEmpty()
//    }
//}
//
//struct Stack {
//    fileprivate var array: [NSAttributedString] = []
//    
//    mutating func push(_ element: NSAttributedString) {
//      array.append(element)
//    }
//    
//    mutating func pop() -> NSAttributedString? {
//      return array.popLast()
//    }
//    
//    func peek() -> NSAttributedString? {
//      return array.last
//    }
//    
//    mutating func clean() {
//        array.removeAll()
//    }
//    
//    mutating func isEmpty() -> Bool {
//        array.isEmpty
//    }
//}
