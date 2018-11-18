//
//  ClassContext.swift
//  NoteWiki
//
//  Created by Liam on 10/10/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

struct ClassContext: Codable {
    var name: String
    var units: [Unit]
}

struct Unit: Codable {
    var name: String
    var link: String
    var index: Int
}
