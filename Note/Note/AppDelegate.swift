//
//  AppDelegate.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storageManager = ServiceLocator.firstAppLaunch()
        if !storageManager.getBoolFromUserDefaults(key: .notFirstLaunch) {
            createDefaulNote(storageManager: storageManager)
            storageManager.saveBoolToUserDefaults(bool: true, key: .notFirstLaunch)
        }
        return true
    }

    func createDefaulNote(storageManager: FirstLaunchStorageManager) {
        let font = UIFont.systemFont(ofSize: 20)
        let title = "Note App"
        let body = "Created By Marin Aleksey"
        let titleAttr = NSMutableAttributedString(string:  title)
        titleAttr.addAttributes([NSAttributedString.Key.font : font], range: NSRange(location: 0,length: title.count))
        let bodyAttr = NSMutableAttributedString(string:  body)
        bodyAttr.addAttributes([NSAttributedString.Key.font : font], range: NSRange(location: 0,length: body.count))
        let titleData = Convertor.mutableAttributedStringToData(string: titleAttr)
        let bodyData = Convertor.mutableAttributedStringToData(string: bodyAttr)
        let currentDate = Date()
        let note = Note(id: UUID().uuidString , titleAtributed: titleData, bodyAtributed: bodyData,date: currentDate)
        storageManager.saveNoteToUserDefaults(note: note, key: note.id, new: true)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

