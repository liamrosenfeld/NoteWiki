//
//  HomeController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Vapor

final class HomeController {
    func get(_ req: Request) throws -> Future<View> {
        let classes = getClasses()
        let context = HomeContext(classes: classes)

        return try req.view().render("home", context)
    }

    func getClasses() -> [Class] {
        let fileManager = FileManager.default
        let absolutePath = "/Users/liam/github/NoteWiki/Markdown/"

        var classes = [Class]()
        var subpaths: [String]!

        do {
            subpaths = try fileManager.subpathsOfDirectory(atPath: absolutePath)
        } catch {
            return classes
        }

        for item in subpaths {
            if item.contains("/") || item.contains(".") { continue }
            let name = item.camelCaseToWords()
            let link = "./\(item)/"
            let newElement = Class(name: name, link: link)
            classes.insert(newElement, at: 0)
        }

        classes.sort { $0.name < $1.name }

        return classes
    }
}

struct HomeContext: Codable {
    var classes: [Class]
}

struct `Class`: Codable {
    var name: String
    var link: String
}
