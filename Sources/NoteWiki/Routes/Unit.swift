//
//  Unit.swift
//  NoteWiki
//
//  Created by Liam on 10/10/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import Foundation
import LoggerAPI

func showUnitPage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void ) {
    let requested = UnitPage.getParameters(from: request)!

    let className: String = requested.class
    let unitName: String = requested.unit

    let path = "Markdown/\(className)/\(unitName)"
    let firstNote = UnitPage.firstNote(at: path)

    if let firstNote = firstNote {
        do {
            try response.redirect("./\(firstNote)", status: .movedPermanently)
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

struct UnitPage {

    static func firstNote(at path: String) -> String? {
        let fileManager = FileManager.default
        let absolutePath = StaticFileServer(path: path).absoluteRootPath
        let enumerator: FileManager.DirectoryEnumerator? = fileManager.enumerator(atPath: absolutePath)

        while let element = enumerator?.nextObject() as? String {
            if element.hasSuffix("md") && element.hasPrefix("01") {
                return String(element.dropLast(3))
            }
        }

        return nil
    }

    static func getParameters(from request: RouterRequest) -> Parameter? {
        guard let requestedClass = request.parameters["class"] else {
            return nil
        }
        guard let requestedUnit = request.parameters["unit"] else {
            return nil
        }

        return Parameter(class: requestedClass, unit: requestedUnit)
    }

    struct Parameter {
        var `class`: String
        var unit: String
    }

}
