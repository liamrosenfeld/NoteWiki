//
//  NoteController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Vapor
import SwiftMarkdown

final class NoteController {
    func get(_ req: Request) throws -> Future<View> {
        let requested = getParameters(from: req)!
        
        let mdPath = "Markdown/\(requested.class)/\(requested.unit)/\(requested.note).md"
        let markdown = renderMarkdown(at: mdPath)
        let unitPath = "Markdown/\(requested.class)/\(requested.unit)"
        let menu = getMenu(at: unitPath)
        let selectedIndex = Int(requested.note.prefix(2))! - 1
        
        var context: NoteContext?
        if let markdown = markdown {
            context = NoteContext(note: markdown, menu: menu, selected: selectedIndex)
        } else {
            throw Abort(.notFound)
        }
        
        print(context!.menu)
        return try req.view().render("note", context!)
    }
    
    func renderMarkdown(at path: String) -> String? {
        var markdown: String?
        let absolutePath = "/Users/liam/github/NoteWiki/\(path)"
        
        do {
            markdown = try String(contentsOfFile: absolutePath, encoding: String.Encoding.utf8) as String
            markdown = try markdownToHTML(markdown!)
        } catch {
            return nil
        }

        return markdown
    }
    
    func getMenu(at path: String) -> [Menu] {
        let fileManager = FileManager.default
        let absolutePath = "/Users/liam/github/NoteWiki/\(path)"
        let enumerator: FileManager.DirectoryEnumerator? = fileManager.enumerator(atPath: absolutePath)
        
        var menuElements = [Menu]()
        
        while let element = enumerator?.nextObject() as? String {
            if element.hasSuffix("md") {
                let name = String(element.dropFirst(3).dropLast(3)).camelCaseToWords()
                let link = "./\(element.dropLast(3))"
                let index = Int(element.prefix(2))! - 1
                let newElement = Menu(name: name, link: link, index: index)
                menuElements.insert(newElement, at: 0)
            }
        }
        
        return menuElements
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
