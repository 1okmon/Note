//
//  NoteEditorViewController+PickerView.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension NoteEditorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func getFontSizePickerBarItem() -> UIBarButtonItem {
        picker.frame = CGRect.init(x: view.frame.width - 100, y: view.frame.height - 150, width: 60, height: 100)
        picker.dropShadow(radius: CGFloat (10))
        let sizePickerButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(openSizePicker))
        sizePickerButton.setBackgroundImage(UIImage(systemName: "textformat.size"), for: .normal, barMetrics: .default)
        sizePickerButton.tintColor = .black
        return sizePickerButton
    }
    
    func changeFontSize(size: CGFloat) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        highlightedSector = firstResponder.selectedRange
        let font = firstResponder.font?.withSize(size)
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.font: font as Any])
        firstResponder.selectedRange = highlightedSector
    }
    
    @IBAction func openSizePicker(_ sender: Any) {
        picker.isHidden = !picker.isHidden
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeFontSize(size: CGFloat(pickerData[row]))
    }
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        
        if let v = view {
            label = v as! UILabel
        }
        
        label.font = UIFont (name: "Helvetica Neue", size: 14)
        label.text =  pickerData[row].formatted()
        label.textAlignment = .center
        return label
    }
}
