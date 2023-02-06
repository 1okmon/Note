//
//  NoteEditorViewController+ImagePicker.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController {
    func getImagePickerBarItem() -> UIBarButtonItem {
        let addImageButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(openImagePicker))
        addImageButton.setBackgroundImage(UIImage(systemName: "plus.rectangle.on.rectangle"), for: .normal, barMetrics: .default)
        addImageButton.tintColor = .black
        return addImageButton
    }
    
    @objc func openImagePicker(_ sender: UITapGestureRecognizer) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        
        lastFirstResponder = (firstResponder, firstResponder.selectedRange)
        let alert = UIAlertController(title: "Photo", message: nil, preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "From Gallary", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "From Camera", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addImageToText(image: UIImage, firstResponder: UITextView, range: NSRange) {
        let attrStringWithImage = NSAttributedString(attachment: NSTextAttachment(image: image))
        let attributedString = NSMutableAttributedString(attributedString: firstResponder.attributedText)
        attributedString.replaceCharacters(in: range, with: attrStringWithImage)
        firstResponder.setAttributedString(attributedString: attributedString)
    }
}

extension NoteEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let responder = lastFirstResponder else {
                dismiss(animated: true, completion: nil)
                return
            }
            guard let image = pickedImage.applyByWidth(width: view.frame.width / 2) else {
                dismiss(animated: true, completion: nil)
                return
            }
            addImageToText(image: image, firstResponder: responder.textView, range: responder.range)
        }
        dismiss(animated: true, completion: nil)
    }
}
