//
//  NoteEditorViewController+DeleteTabBarButton.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//

import Foundation
import UIKit
extension NoteEditorViewController {
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
