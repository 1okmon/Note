//
//  NoteEditorViewController+Undo.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController {
    func getUndoBarItem() -> UIBarButtonItem {
        let undoButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(undo))
        undoButton.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal, barMetrics: .default)
        undoButton.isEnabled = false
        undoButton.tintColor = .lightGray
        return undoButton
    }
    
    func getRedoBarItem() -> UIBarButtonItem {
        let redoButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(redo))
        redoButton.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal, barMetrics: .default)
        redoButton.isEnabled = false
        redoButton.tintColor = .lightGray
        return redoButton
    }
    
    @IBAction func undo(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        firstResponder.undoManager?.undo()
        updateUndoButtons()
    }
    
    @IBAction func redo(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        firstResponder.undoManager?.redo()
        updateUndoButtons()
    }

    func updateUndoButtons() {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        undoButton.isEnabled = firstResponder.undoManager?.canUndo ?? false
        redoButton.isEnabled = firstResponder.undoManager?.canRedo ?? false
        
        if undoButton.isEnabled {
            undoButton.tintColor = .black
        } else {
            undoButton.tintColor = .lightGray
        }
        
        if redoButton.isEnabled {
            redoButton.tintColor = .black
        } else {
            redoButton.tintColor = .lightGray
        }
    }
}
