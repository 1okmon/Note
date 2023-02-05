//
//  NoteEditorViewController.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//

import UIKit

class NoteEditorViewController: UIViewController {
    
    @IBOutlet weak var TitleTextView: UITextView!
    @IBOutlet weak var BodyTextView: UITextView!
    
    var needToDelete = false
    var note: Note?
    let defaultFontForTitle = UIFont.systemFont(ofSize: 24)
    let defaultFontForBody = UIFont.systemFont(ofSize: 20)
    var placeholder = "Title"
    let storageManager = ServiceLocator.notesStorageManager()
    var undoButton: UIBarButtonItem!
    var redoButton: UIBarButtonItem!
    var highlightedSector = NSRange()
    let imagePicker = UIImagePickerController()
    var lastFirstResponder: (textView: UITextView, range: NSRange)?
    
    var dotListModeIsActive = false
    var attributedStringForDotInList = NSMutableAttributedString()
    var attributedStringForNewLine = NSMutableAttributedString()
    
    let colorWell: UIColorWell = {
       let colorWell = UIColorWell()
        colorWell.supportsAlpha = true
        colorWell.title = "Color well"
        return colorWell
    }()
    
    let colorWell2: UIColorWell = {
       let colorWell = UIColorWell()
        colorWell.supportsAlpha = true
        colorWell.title = "Color well"
        return colorWell
    }()
    
    let pickerData: [Int] = {
        let minNum = 6
        let maxNum = 63
        let pickerData = Array(stride(from: minNum, to: maxNum + 2, by: 2))
        return pickerData
    }()
    
    let picker: UIPickerView = {
        let picker = UIPickerView.init()
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        return picker
    }()
    
    
    func setupFontSizePicker () {
        picker.delegate = self
        picker.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightButtonToNavigationBar()
        TitleTextView.delegate = self
        BodyTextView.delegate = self
        imagePicker.delegate = self
        
        attributedStringForDotInList = NSMutableAttributedString(string: "\u{2022}", attributes: [NSAttributedString.Key.font : defaultFontForBody as Any])
        attributedStringForNewLine = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : defaultFontForBody as Any])
        
        if let note = note {
            TitleTextView.attributedText = Convert.dataToMutableAttributedString(data: note.titleAtributed)
            TitleTextView.textColor = UIColor.black
            let text = Convert.dataToMutableAttributedString(data: note.bodyAtributed)
            BodyTextView.attributedText = text
            if text.string == "" {
                BodyTextView.font =  defaultFontForBody
            }
        } else {
            BodyTextView.font =  defaultFontForBody
        }
        if TitleTextView.attributedText.string == "" {
            TitleTextView.text = placeholder
            TitleTextView.font =  defaultFontForTitle
            TitleTextView.textColor = UIColor.lightGray
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupFontSizePicker()
        configureToolbar()
        view.addSubview(picker)
        self.picker.isHidden = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if picker.frame.origin.y == view.frame.height - 150 {
                picker.frame.origin.y -= keyboardSize.height - 40
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if picker.frame.origin.y != view.frame.height - 150 {
            picker.frame.origin.y = view.frame.height - 150
        }
    }
    
    func configureToolbar() {
        let height = CGFloat(50)
        let widthBtwButtons = CGFloat(30)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: height))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(systemName: "character.textbox"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: widthBtwButtons).isActive = true
        let textBackgroundColorPicker = UIBarButtonItem(customView: button)
        textBackgroundColorPicker.tintColor = .black
        colorWell.addTarget(self, action: #selector(changeTextBackgroundColor), for: .valueChanged)
        textBackgroundColorPicker.customView?.addSubview(colorWell)
        
        let button2 = UIButton.init(type: .custom)
        button2.setImage(UIImage(systemName: "character"), for: .normal)
        button2.widthAnchor.constraint(equalToConstant: widthBtwButtons).isActive = true
        let textColorPicker = UIBarButtonItem(customView: button2)
        textColorPicker.tintColor = .black
        colorWell2.addTarget(self, action: #selector(changeTextColor), for: .valueChanged)
        textColorPicker.customView?.addSubview(colorWell2)
        
        
        let listActivate = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(toggleListActivation))
        listActivate.setBackgroundImage(UIImage(systemName: "list.bullet"), for: .normal, barMetrics: .default)
        
        let addImageButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(openImagePicker))
        addImageButton.setBackgroundImage(UIImage(systemName: "plus.rectangle.on.rectangle"), for: .normal, barMetrics: .default)
        addImageButton.tintColor = .black
        
        picker.frame = CGRect.init(x: view.frame.width - 100, y: view.frame.height - 150, width: 60, height: 100)
        picker.dropShadow(radius: CGFloat (10))
        let sizePickerButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(openSizePicker))
        sizePickerButton.setBackgroundImage(UIImage(systemName: "number"), for: .normal, barMetrics: .default)
        sizePickerButton.tintColor = .black
    
        let boldButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(applyBold))
        boldButton.setBackgroundImage(UIImage(systemName: "bold"), for: .normal, barMetrics: .default)
        boldButton.tintColor = .black
        
        let italicButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(applyItalic))
        italicButton.setBackgroundImage(UIImage(systemName: "italic"), for: .normal, barMetrics: .default)
        italicButton.tintColor = .black
        
        undoButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(undo))
        undoButton.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal, barMetrics: .default)
        undoButton.isEnabled = false
        undoButton.tintColor = .lightGray
        
        redoButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(redo))
        redoButton.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal, barMetrics: .default)
        redoButton.isEnabled = false
        redoButton.tintColor = .lightGray
        
        
        toolbar.items = [listActivate, flexibleSpace, addImageButton, boldButton, italicButton, textColorPicker, textBackgroundColorPicker, sizePickerButton, undoButton, redoButton]
        toolbar.sizeToFit()
        TitleTextView.inputAccessoryView = toolbar
        BodyTextView.inputAccessoryView = toolbar
    }
    
    @IBAction func openSizePicker(_ sender: Any) {
        picker.isHidden = !picker.isHidden
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
    
    @IBAction func undo(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        firstResponder.undoManager?.undo()
        updateUndoButtons()
    }
    
    @IBAction func applyBold(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        highlightedSector = firstResponder.selectedRange
        firstResponder.selectedRange = NSRange(location: 0,length: 0)
        firstResponder.selectedRange = highlightedSector
        let attrString = firstResponder.attributedText.attributedSubstring(from: highlightedSector)
        print(attrString)
        let font = firstResponder.font?.bold()
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.font: font as Any])
        firstResponder.selectedRange = highlightedSector
    }
    
    @IBAction func applyItalic(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        highlightedSector = firstResponder.selectedRange
        let font = firstResponder.font?.italic()
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.font: font as Any])
        firstResponder.selectedRange = highlightedSector
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
            undoButton.tintColor = .blue
        } else {
            undoButton.tintColor = .lightGray
        }
        
        if redoButton.isEnabled {
            redoButton.tintColor = .blue
        } else {
            redoButton.tintColor = .lightGray
        }
    }
    
    
    @IBAction func changeTextBackgroundColor(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        highlightedSector = firstResponder.selectedRange
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.backgroundColor: colorWell.selectedColor])
        firstResponder.selectedRange = highlightedSector
    }
    
    @IBAction func changeTextColor(_ sender: Any) {
        guard let firstResponder = view.window?.firstResponder as? UITextView else {
            return
        }
        highlightedSector = firstResponder.selectedRange
        applyTextChanges(firstResponder: firstResponder, highlightedSector: highlightedSector, attributes: [NSAttributedString.Key.foregroundColor: colorWell2.selectedColor])
        firstResponder.selectedRange = highlightedSector
    }
    
    

    func applyTextChanges(firstResponder: UITextView, highlightedSector: NSRange, attributes: [NSAttributedString.Key: Any]) {
        let myAttrString = NSMutableAttributedString(attributedString: firstResponder.attributedText)
        myAttrString.addAttributes(attributes, range: highlightedSector)
        firstResponder.setAttributedString(attributedString: myAttrString)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var new = false
        if TitleTextView.text == placeholder && TitleTextView.attributedText.string == placeholder {
            TitleTextView.text = ""
        }
        
        guard !needToDelete && !(BodyTextView.attributedText.string == "" && TitleTextView.attributedText.string == "") || note != nil else {
            return
        }
        
        let titleData = Convert.mutableAttributedStringToData(string: TitleTextView.attributedText)
        let bodyData = Convert.mutableAttributedStringToData(string: BodyTextView.attributedText)
        let currentDate = Date()
        if note == nil {
            new = true
        }
        
        let note = Note(id: note?.id ?? UUID().uuidString , titleAtributed: titleData, bodyAtributed: bodyData,date: currentDate)
        storageManager.saveNoteToUserDefaults(note: note, key: note.id, new: new)
    }
    
    func addRightButtonToNavigationBar() {
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(deleteNote))
        let infoImage = UIImage(systemName: "trash")
        addButton.setBackgroundImage(infoImage, for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func deleteNote(sender: AnyObject) {
        let alert = UIAlertController(title: "Удалить заметку?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { action in
            if let note = self.note {
                self.storageManager.removeNoteFromUserDefaults(key: note.id)
            }
            self.needToDelete = true
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !TitleTextView.attributedText.string.isEmpty && TitleTextView.text == placeholder {
            TitleTextView.attributedText = NSAttributedString("")
            TitleTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoButtons()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var locationOfRowBeginning = textView.getLocationOfRowBeginingInSelectedRange()
        guard textView.attributedText.string.count > 0 else {
            return true
        }
//        if locationOfRowBeginning == 0 {
//            locationOfRowBeginning -= 1
//        }
        
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

extension NoteEditorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
  
    func dropShadow(scale: Bool = true, radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}

extension UIFont {
    
    func bold() -> UIFont {
        applyTraits(traits: [.traitBold], alreadyApplied: isBold)
    }
    
    func italic() -> UIFont {
        print(isItalic)
        return applyTraits(traits: [.traitItalic], alreadyApplied: isItalic)
    }
    
    private func applyTraits(traits:UIFontDescriptor.SymbolicTraits, alreadyApplied: Bool) -> UIFont {
        if alreadyApplied {
            var symTraits = fontDescriptor.symbolicTraits
            symTraits.remove(traits)
            guard let descriptor = fontDescriptor.withSymbolicTraits(symTraits) else {
                return self
            }
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            var symTraits = fontDescriptor.symbolicTraits
            symTraits.insert(traits)
            guard let descriptor = fontDescriptor.withSymbolicTraits(symTraits) else {
                return self
            }
            return UIFont(descriptor: descriptor, size: 0)
        }
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}

extension UIImage {
    func applyByWidth(width: CGFloat) -> UIImage? {
        let scaleCoefficient = self.size.width / width
        let newWidth  = self.size.width / scaleCoefficient
        let newHeight = self.size.height / scaleCoefficient
        
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    func insert (range: NSRange, string: NSAttributedString) -> NSAttributedString {
        let rangeOfHead = NSRange(location: 0, length: range.location)
        let rangeOFTail = NSRange(location: range.location + range.length, length: self.string.count - (range.location + range.length))
        let result = self.attributedSubstring(from: rangeOfHead) + string + self.attributedSubstring(from: rangeOFTail)
        return result
    }
}

extension UITextView {
    func getLocationOfRowBeginingInSelectedRange() -> (Int) {
        for i in stride(from: selectedRange.location - 1, through: 0, by: -1) {
            if (self.attributedText.attributedSubstring(from: NSRange(location: i, length: 1)).string == "\n") {
                return i
            }
        }
        return 0
    }
    
    
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
