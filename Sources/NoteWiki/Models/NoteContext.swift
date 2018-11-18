//
//  NoteContext.swift
//  CHTTPParser
//
//  Created by Liam on 10/7/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

struct NoteContext: Codable {
    var note: String
    var menu: [Menu]
    var index: Int
}

struct Menu: Codable {
    var name: String
    var link: String
    var index: Int
}
