//
//  NoteEditorViewController.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//
import UIKit
class NoteEditorViewController: UIViewController, UIGestureRecognizerDelegate {
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
    let colorPicker = UIColorPickerViewController()
    var lastFirstResponder: (textView: UITextView, range: NSRange)?
    var dotListModeIsActive = false
    var attributedStringForDotInList = NSMutableAttributedString()
    var attributedStringForNewLine = NSMutableAttributedString()
    var selectedColor = UIColor.clear
    var selectedAttribute = NSAttributedString.Key.backgroundColor
    
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
    
    func setupDelegates () {
        TitleTextView.delegate = self
        BodyTextView.delegate = self
        imagePicker.delegate = self
        colorPicker.delegate = self
        picker.delegate = self
        picker.dataSource = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecogniser))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func setupPropertiesForFields() {
        attributedStringForDotInList = NSMutableAttributedString(string: "\u{2022}", attributes: [NSAttributedString.Key.font : defaultFontForBody as Any])
        attributedStringForNewLine = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : defaultFontForBody as Any])
        
        if let note = note {
            TitleTextView.attributedText = Convertor.dataToMutableAttributedString(data: note.titleAtributed)
            TitleTextView.textColor = UIColor.black
            let text = Convertor.dataToMutableAttributedString(data: note.bodyAtributed)
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
        
        view.addSubview(picker)
        self.picker.isHidden = true
    }
    
    @IBAction func tapGestureRecogniser(_ sender: Any) {
        self.view.firstResponder?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightButtonToNavigationBar()
        setupDelegates()
        setupPropertiesForFields()
        subscribeKeyboardNotidication()
        configureToolbar()
    }
    
    deinit {
        unscribeKeyboardNotidication()
    }
    
    func configureToolbar() {
        let height = CGFloat(50)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: height))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let textBackgroundColorPicker = getColorPickerBarItem(imageName: "character.textbox", action: #selector(pickTextBackgroundColor))
        let textColorPicker = getColorPickerBarItem(imageName: "character", action: #selector(pickTextColor))
        let listActivateBarButton = getListToggleBarItem()
        let sizePickerButton = getFontSizePickerBarItem()
        let addImageButton = getImagePickerBarItem()
        let boldButton = getBoldToggleBarItem()
        let italicButton = getItalicToggleBarItem()
        undoButton = getUndoBarItem()
        redoButton = getRedoBarItem()
        toolbar.items = [listActivateBarButton, addImageButton, flexibleSpace, boldButton, italicButton, textColorPicker, textBackgroundColorPicker, sizePickerButton, flexibleSpace, undoButton, redoButton]
        toolbar.sizeToFit()
        TitleTextView.inputAccessoryView = toolbar
        BodyTextView.inputAccessoryView = toolbar
    }

    func applyTextChanges(firstResponder: UITextView, highlightedSector: NSRange, attributes: [NSAttributedString.Key: Any]) {
        let myAttrString = NSMutableAttributedString(attributedString: firstResponder.attributedText)
        myAttrString.addAttributes(attributes, range: highlightedSector)
        firstResponder.setAttributedString(attributedString: myAttrString)
        updateUndoButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNoteIfNeeded()
    }
    
    func saveNoteIfNeeded() {
        var new = false
        
        if TitleTextView.text == placeholder && TitleTextView.attributedText.string == placeholder {
            TitleTextView.text = ""
        }
        
        guard !needToDelete && !(BodyTextView.attributedText.string == "" && TitleTextView.attributedText.string == "") || note != nil else {
            return
        }
        
        let titleData = Convertor.mutableAttributedStringToData(string: TitleTextView.attributedText)
        let bodyData = Convertor.mutableAttributedStringToData(string: BodyTextView.attributedText)
        let currentDate = Date()
        
        if note == nil {
            new = true
        }
        
        let note = Note(id: note?.id ?? UUID().uuidString , titleAtributed: titleData, bodyAtributed: bodyData,date: currentDate)
        storageManager.saveNoteToUserDefaults(note: note, key: note.id, new: new)
    }
}
