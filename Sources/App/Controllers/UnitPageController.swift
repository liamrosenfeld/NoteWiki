//
//  UnitController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor
import Fluent

final class UnitPageController {
    func get(_ req: Request) throws -> Future<Response> {
        let requested = getParameters(from: req)!
        
        let className: String = requested.class
        let unitName: String = requested.unit
        
        return Note.query(on: req).filter(\.`class` == className).filter(\.unit == unitName).all().map(to: Response.self) { notes in
            var rawNotes = [String]()
            for note in notes {
                rawNotes.append(note.class)
            }
            
            rawNotes = Array(Set(rawNotes)) // Delete Duplicates
            
            var firstNote: String?
            for note in rawNotes {
                if note.hasPrefix("01") {
                    firstNote = note
                }
            }
            
            guard let validFirstNote = firstNote else {
                throw Abort(.notFound)
            }
            
            return req.redirect(to: "./\(validFirstNote)", type: .permanent)
        }
    }
    
    func getParameters(from req: Request) -> Parameter? {
        var requestedClass: String!
        var requestedUnit: String!
        
        do {
            requestedClass = try req.parameters.next(String.self)
            requestedUnit  = try req.parameters.next(String.self)
        } catch {
            return nil
        }
        
        return Parameter(class: requestedClass, unit: requestedUnit)
    }
    
    struct Parameter {
        var `class`: String
        var unit: String
    }

}
