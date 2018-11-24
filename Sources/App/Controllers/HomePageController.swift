//
//  HomeController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Vapor

final class HomePageController {
    func get(_ req: Request) throws -> Future<View> {
        return Note.query(on: req).all().map(to: [String].self) { notes in
            var rawClasses = [String]()
            for note in notes {
                rawClasses.append(note.class)
            }
            
            rawClasses = Array(Set(rawClasses)) // Delete Duplicates
            
            return rawClasses
        }.map(to: [Class].self) { rawClasses in
            var classes = [Class]()
            for item in rawClasses {
                if item.contains("/") || item.contains(".") { continue }
                let name = item.camelCaseToWords()
                let link = "./\(item)/"
                let newElement = Class(name: name, link: link)
                classes.insert(newElement, at: 0)
            }
            
            classes.sort { $0.name < $1.name }
            
            return classes
        }.flatMap(to: View.self) { classes in
            let context = HomeContext(classes: classes)
            return try req.view().render("home", context)
        }
    }
}

struct HomeContext: Codable {
    var classes: [Class]?
}

struct `Class`: Codable {
    var name: String
    var link: String
}
