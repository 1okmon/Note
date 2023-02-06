//
//  ServiceLocator.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//
import Foundation
struct ServiceLocator {
    static func notesStorageManager () ->
    NotesStorageManager {
        StorageManager()
    }
    
    static func firstAppLaunch () ->
    FirstLaunchStorageManager {
        StorageManager()
    }
}
