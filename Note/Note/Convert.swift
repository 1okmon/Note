//
//  Convert.swift
//  Note
//
//  Created by 1okmon on 02.02.2023.
//

import Foundation


class Convert {
    
    static func mutableAttributedStringToData(string: NSAttributedString) -> Data {
        var stringData = NSData()

        do {
            stringData = try NSKeyedArchiver.archivedData(withRootObject: string, requiringSecureCoding: false) as NSData
        } catch let err {
            print("error archiving string data", err)
        }
        return Data(referencing: stringData)
    }

    static func dataToMutableAttributedString(data: Data) -> NSAttributedString {
        var string = NSAttributedString()
        do {
            string = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data) ?? NSAttributedString()
        } catch let err {
            print("error extracting string data", err)
        }
        return string
    }
}
