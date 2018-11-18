//
//  Note.swift
//  NoteWiki
//
//  Created by Liam on 10/7/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import KituraMarkdown
import LoggerAPI
import Foundation

func showNotePage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void ) {
    let requested = NotePage.getParameters(from: request)!

    let mdPath = "Markdown/\(requested.class)/\(requested.unit)/\(requested.note).md"
    let markdown = NotePage.renderMarkdown(at: mdPath)
    let unitPath = "Markdown/\(requested.class)/\(requested.unit)"
    let menu = NotePage.getMenu(at: unitPath)
    let index = Int(requested.note.prefix(2))! - 1

    if let markdown = markdown {
        let context = NoteContext(note: markdown, menu: menu, index: index)
        do {
            try response.render("note.stencil", with: context)
        } catch let error {
            response.status(.internalServerError).send(error.localizedDescription)
        }
    } else {
        do {
            try response.status(.notFound).redirect("/404")
        } catch let error {
            response.status(.internalServerError).send(error.localizedDescription)
        }
    }

}

struct NotePage {
    static func renderMarkdown(at path: String) -> String? {
        var markdown: String?
        let absolutePath = StaticFileServer(path: path).absoluteRootPath

        do {
            markdown = try String(contentsOfFile: absolutePath, encoding: String.Encoding.utf8) as String
        } catch {
            return nil
        }

        let renderedMardown = KituraMarkdown.render(from: markdown!)
        return renderedMardown
    }

    static func getMenu(at path: String) -> [Menu] {
        let fileManager = FileManager.default
        let absolutePath = StaticFileServer(path: path).absoluteRootPath
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

    static func getParameters(from request: RouterRequest) -> Parameter? {
        guard let requestedClass = request.parameters["class"] else {
            return nil
        }
        guard let requestedUnit = request.parameters["unit"] else {
            return nil
        }
        guard let requestedNote = request.parameters["note"] else {
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
