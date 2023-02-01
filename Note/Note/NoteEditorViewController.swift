//
//  NoteEditorViewController.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//

import UIKit

class NoteEditorViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var TitleTextView: UITextView!
    @IBOutlet weak var BodyTextView: UITextView!
    
    var needToDelete = false
    var head = String()
    var body = String()
    var noteId = String()
    var placeholder = "Title"
    let storageManager = ServiceLocator.notesStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightButtonToNavigationBar()
        TitleTextView.delegate = self
        if head == "" {
            TitleTextView.text = placeholder
            TitleTextView.textColor = UIColor.lightGray
        } else {
            TitleTextView.text = head
            TitleTextView.textColor = UIColor.black
        }
        BodyTextView.text = body
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var new = false
        guard !needToDelete && !(BodyTextView.text == "" &&  noteId == "" && (TitleTextView.text == "" || TitleTextView.textColor == .lightGray)) else {
            return
        }
        if noteId == "" {
            new = true
            noteId = UUID().uuidString
        }
        if TitleTextView.textColor == .lightGray {
            TitleTextView.text = ""
        }
        let currentDate = Date()
        let note = Note(id: noteId , title: TitleTextView.text, body: BodyTextView.text, date: currentDate)
        storageManager.saveNoteToUserDefaults(note: note, key: noteId, new: new)
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
            self.storageManager.removeNoteFromUserDefaults(key: self.noteId)
            self.needToDelete = true
            if let navController = self.navigationController {
                navController.popToRootViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !TitleTextView.text.isEmpty && TitleTextView.text == placeholder {
            TitleTextView.text = ""
            TitleTextView.textColor = UIColor.black
        }
    }
}
