//
//  Class.swift
//  NoteWiki
//
//  Created by Liam on 10/10/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import Foundation
import LoggerAPI

func showClassPage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void ) {
    let requested = ClassPage.getParameters(from: request)!

    let className: String = requested.class
    let path = "Markdown/\(className)"
    let name = className.camelCaseToWords()
    let units = ClassPage.getUnits(at: path)

    if !units.isEmpty {
        let context = ClassContext(name: name, units: units)
        do {
            try response.render("class.stencil", with: context)
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

struct ClassPage {
    static func getUnits(at path: String) -> [Unit] {
        let fileManager = FileManager.default
        let absolutePath = StaticFileServer(path: path).absoluteRootPath

        var units = [Unit]()
        var subpaths: [String]!

        do {
            subpaths = try fileManager.subpathsOfDirectory(atPath: absolutePath)
        } catch {
            return units
        }

        for unit in subpaths {
            if unit.contains("/") || unit.contains(".") { continue }
            let name = String(unit.dropFirst(3)).camelCaseToWords()
            let link = "./\(unit)/"
            let index = Int(unit.prefix(2))! - 1
            let newElement = Unit(name: name, link: link, index: index)
            units.insert(newElement, at: 0)
        }

        return units
    }

    static func getParameters(from request: RouterRequest) -> Parameter? {
        guard let requestedClass = request.parameters["class"] else {
            return nil
        }

        return Parameter(class: requestedClass)
    }

    struct Parameter {
        var `class`: String
    }
}
