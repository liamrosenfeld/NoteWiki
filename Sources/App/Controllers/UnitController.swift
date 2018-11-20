//
//  UnitController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Vapor

final class UnitController {
    func get(_ req: Request) throws -> Response {
        let requested = getParameters(from: req)!
        
        let className: String = requested.class
        let unitName: String = requested.unit
        
        let path = "Markdown/\(className)/\(unitName)"
        let firstNote = findFirstNote(at: path)
        
        var redirect: Response?
        if let firstNote = firstNote {
            redirect = req.redirect(to: "./\(firstNote)", type: .permanent)
        } else {
            throw Abort(.notFound)
        }
        
        return redirect!
    }
    
    func findFirstNote(at path: String) -> String? {
        let fileManager = FileManager.default
        let absolutePath = "/Users/liam/github/NoteWiki/\(path)"
        let enumerator: FileManager.DirectoryEnumerator? = fileManager.enumerator(atPath: absolutePath)
        
        while let element = enumerator?.nextObject() as? String {
            if element.hasSuffix("md") && element.hasPrefix("01") {
                return String(element.dropLast(3))
            }
        }
        
        return nil
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
