//
//  NoteEditorViewController+ColorPicker.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController {
    func getColorPickerBarItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let addImageButton = UIBarButtonItem(title: "", style: .plain, target: self, action: action)
        addImageButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal, barMetrics: .default)
        addImageButton.tintColor = .black
        return addImageButton
    }
    
    @IBAction func pickTextBackgroundColor(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        lastFirstResponder = (textView: firstResponder, range: firstResponder.selectedRange)
        selectedAttribute = .backgroundColor
        colorPicker.supportsAlpha = false
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func pickTextColor(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        lastFirstResponder = (textView: firstResponder, range: firstResponder.selectedRange)
        selectedAttribute = .foregroundColor
        colorPicker.supportsAlpha = false
        self.present(colorPicker, animated: true, completion: nil)
    }
}

extension NoteEditorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let firstResponder = lastFirstResponder else {
            return
        }
        
        applyTextChanges(firstResponder: firstResponder.textView, highlightedSector: firstResponder.range, attributes: [selectedAttribute: viewController.selectedColor])
        updateUndoButtons()
    }
}
