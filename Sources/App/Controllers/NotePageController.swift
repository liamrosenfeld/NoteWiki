//
//  NoteController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor
import Fluent
import SwiftMarkdown

final class NotePageController {
    func get(_ req: Request) throws -> Future<View> {
        let requested = getParameters(from: req)!
        let className = requested.class
        let unitName  = requested.unit
        let noteName  = requested.note
        
        return Note.query(on: req).filter(\.`class` == className).filter(\.unit == unitName).all().flatMap(to: View.self) { notes in
            var menu = [Menu]()
            var chosenNote: Note?
            var selectedIndex: Int?
            for note in notes {
                let name = String(note.note.dropFirst(3)).camelCaseToWords()
                let link = "./\(note.note)"
                let index = Int(note.note.prefix(2))! - 1
                let newElement = Menu(name: name, link: link, index: index)
                menu.insert(newElement, at: 0)
                
                if note.note == noteName {
                    chosenNote = note
                    selectedIndex = Int(note.note.prefix(2))! - 1
                }
            }
            
            guard let note = chosenNote, let index = selectedIndex else {
                print("ERR: No Note Found")
                throw Abort(.notFound)
            }
            
            var context: NoteContext!
            do {
                let markdown = try markdownToHTML(note.content)
                context = NoteContext(note: markdown, menu: menu, selected: index)
            } catch {
                print("ERR: HTML Convertion Error")
                throw Abort(.internalServerError)
            }

            return try req.view().render("note", context!)
        }
    }
    
    func getParameters(from req: Request) -> Parameter? {
        var requestedClass: String!
        var requestedUnit: String!
        var requestedNote: String!
        
        do {
            requestedClass = try req.parameters.next(String.self)
            requestedUnit  = try req.parameters.next(String.self)
            requestedNote  = try req.parameters.next(String.self)
        } catch {
            return nil
        }
        
        return Parameter(class: requestedClass, unit: requestedUnit, note: requestedNote)
    }
    
    struct Parameter {
        var `class`: String
        var unit: String
        var note: String
    }
}

struct NoteContext: Codable {
    var note: String
    var menu: [Menu]
    var selected: Int
}

struct Menu: Codable {
    var name: String
    var link: String
    var index: Int
}
