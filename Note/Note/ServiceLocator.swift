//
//  ServiceLocator.swift
//  School
//
//  Created by 1okmon on 19.05.2022.
//

import Foundation

struct ServiceLocator {
    
    static func notesStorageManager () ->
    NotesStorageManager {
        StorageManager()
    }
}
