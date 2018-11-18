//
//  HomePage.swift
//  NoteWiki
//
//  Created by Liam on 10/7/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import Foundation
import LoggerAPI

func showHomePage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void ) {
    let classes = HomePage.getClasses()
    let context = HomeContext(classes: classes)

    do {
        try response.render("home.stencil", with: context)
    } catch let error {
        response.status(.internalServerError).send(error.localizedDescription)
    }
}

struct HomePage {
    static func getClasses() -> [Class] {
        let fileManager = FileManager.default
        let absolutePath = StaticFileServer(path: "Markdown").absoluteRootPath

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
