//
//  ClassController.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Vapor

final class ClassController {
    func get(_ req: Request) throws -> Future<View> {
        let requested = getParameters(from: req)!
        
        let className: String = requested.class
        let path = "Markdown/\(className)"
        let name = className.camelCaseToWords()
        let units = getUnits(at: path)
        
        var context: ClassContext?
        if !units.isEmpty {
            context = ClassContext(name: name, units: units)
        } else {
            throw Abort(.notFound)
        }
        
        return try req.view().render("class", context!)
    }
    
    func getUnits(at path: String) -> [Unit] {
        let fileManager = FileManager.default
        let absolutePath = "/Users/liam/github/NoteWiki/\(path)"
        
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
