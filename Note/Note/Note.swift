//
//  Note.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//

import Foundation

struct Note: Codable {
    var id: String
    //var title: String
    //var body: String
    var titleAtributed: Data
    var bodyAtributed: Data
    var date: Date
}

