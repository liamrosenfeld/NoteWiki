//
//  ClassController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor
import Fluent

final class ClassPageController {
    func get(_ req: Request) throws -> Future<View> {
        let requested = getParameters(from: req)!
        
        let className: String = requested.class
        let name = className.camelCaseToWords()
        
        
        return Note.query(on: req).filter(\.`class` == className).all().map(to: [String].self) { notes in
            guard !notes.isEmpty else {
                throw Abort(.notFound)
            }
            var rawUnits = [String]()
            for note in notes {
                rawUnits.append(note.unit)
            }
            rawUnits = Array(Set(rawUnits)) // Delete Duplicates
            return rawUnits
        }.map(to: [Unit].self) { rawUnits in
            var units = [Unit]()
            for unit in rawUnits {
                let name = String(unit.dropFirst(3)).camelCaseToWords()
                let link = "./\(unit)/"
                let index = Int(unit.prefix(2))! - 1
                let newElement = Unit(name: name, link: link, index: index)
                units.append(newElement)
            }
            return units
        }.flatMap(to: View.self) { units in
            var context: ClassContext?
            context = ClassContext(name: name, units: units)
            return try req.view().render("class", context!)
        }
        
        
        
        
    }
    
    func getParameters(from req: Request) -> Parameter? {
        var requestedClass: String!
        do {
            requestedClass = try req.parameters.next(String.self)
        } catch {
            return nil
        }
        
        return Parameter(class: requestedClass)
    }
    
    struct Parameter {
        var `class`: String
    }
}

struct ClassContext: Codable {
    var name: String
    var units: [Unit]
}

struct Unit: Codable {
    var name: String
    var link: String
    var index: Int
}
