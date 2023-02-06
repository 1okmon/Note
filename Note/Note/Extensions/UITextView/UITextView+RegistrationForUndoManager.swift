//
//  UITextView+.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//

import Foundation
import UIKit
extension UITextView {
    func setAttributedString(attributedString: NSAttributedString?) {
        self.redoOfNewStringRegistration(newString: attributedString, oldString: self.attributedText)
        self.undoManager?.undo()
        self.undoManager?.redo()
    }
    func redoOfNewStringRegistration(newString: NSAttributedString?, oldString: NSAttributedString?) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.attributedText = oldString
            selfTarget.undoOfNewStringRegistration(newString: oldString, oldString: newString)
        })
      }

      func undoOfNewStringRegistration(newString: NSAttributedString?, oldString: NSAttributedString?) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.attributedText = oldString
            selfTarget.redoOfNewStringRegistration(newString: oldString, oldString: newString)
        })
      }
}
