//
//  StorageManager.swift
//  School
//
//  Created by 1okmon on 14.05.2022.
//
import Foundation
import UIKit

protocol NotesStorageManager {
    func saveNoteToUserDefaults(note: Note, key: String, new: Bool?)
    func removeNoteFromUserDefaults(key: String)
    func getNoteFromUserDefaults(key: String) -> Note?
    func getAllNotesFromUserDefaults() -> [Note]
}

extension StorageManager: NotesStorageManager {
    func saveNoteToUserDefaults(note: Note, key: String, new: Bool?) {
        let defaults = UserDefaults.standard
        if new ?? false {
            var ids = defaults.stringArray(forKey: "Notes_ID") ?? [String]()
            ids.insert(key, at: 0)
            
            defaults.set(ids, forKey: "Notes_ID")
        }
        defaults.set(try? PropertyListEncoder().encode(note), forKey:key)
    }
    
    func removeNoteFromUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        var ids = UserDefaults.standard.stringArray(forKey: "Notes_ID") ?? [String]()
        ids = ids.filter { $0 != key}
        UserDefaults.standard.set(ids, forKey: "Notes_ID")
    }
    
    func getNoteFromUserDefaults(key: String) -> Note? {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            let note = try? PropertyListDecoder().decode(Note.self, from: data)
            return note
        }
        
        return nil
    }
    
    func getAllNotesFromUserDefaults() -> [Note] {
        let defaults = UserDefaults.standard
        let ids = defaults.stringArray(forKey: "Notes_ID") ?? [String]()
        print(ids)
        var notes = [Note]()
        for id in ids {
            //removeNoteFromUserDefaults(key: id)
            if let note = getNoteFromUserDefaults(key: id) {
                notes.append(note)
            }
        }
        return notes
    }
}

class StorageManager {
}
