//
//  StorageManager.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//
import Foundation
import UIKit
enum StorageManagerKey: String, CaseIterable {
    case notFirstLaunch
}

protocol NotesStorageManager {
    func saveNoteToUserDefaults(note: Note, key: String, new: Bool?)
    func removeNoteFromUserDefaults(key: String)
    func getNoteFromUserDefaults(key: String) -> Note?
    func getAllNotesFromUserDefaults() -> [Note]
}

protocol FirstLaunchStorageManager {
    func saveBoolToUserDefaults(bool: Bool, key: StorageManagerKey)
    func getBoolFromUserDefaults(key: StorageManagerKey) -> Bool
    func saveNoteToUserDefaults(note: Note, key: String, new: Bool?)
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
        var notes = [Note]()
        for id in ids {
            if let note = getNoteFromUserDefaults(key: id) {
                notes.append(note)
            }
        }
        return notes
    }
}

extension StorageManager: FirstLaunchStorageManager {
    func saveBoolToUserDefaults(bool: Bool, key: StorageManagerKey) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
    }
    
    func getBoolFromUserDefaults(key: StorageManagerKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
}

class StorageManager {
}
