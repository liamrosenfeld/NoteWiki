//
//  FillDatabase.swift
//  NoteWiki
//
//  Created by Liam on 11/20/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Vapor

// TEMP: For Testing
func fillDatabase(_ req: Request) {
    
    req.withPooledConnection(to: .psql) { conn in
        conn.raw("DELETE FROM notes").all()
    }
    
    let fileManager = FileManager.default
    let absolutePath = "/Users/liam/github/NoteWiki/Markdown/"
    
    var subpaths: [String]!
    
    do {
        subpaths = try fileManager.subpathsOfDirectory(atPath: absolutePath)
    } catch {
        print("ERR: GET CLASSES ISSUE")
    }
    
    var classes = [String]()
    for item in subpaths {
        if item.contains("/") || item.contains(".") { continue }
        classes.append(item)
    }
    
    for aClass in classes {
        let classPath = "\(absolutePath)\(aClass)"
        do {
            subpaths = try fileManager.subpathsOfDirectory(atPath: classPath)
        } catch {
            print("ERR: GET UNITS ISSUE")
        }
        
        var units = [String]()
        for item in subpaths {
            if item.contains("/") || item.contains(".") { continue }
            units.insert(item, at: 0)
        }
        
        for unit in units {
            let unitPath = "\(classPath)/\(unit)"
            let enumerator: FileManager.DirectoryEnumerator? = fileManager.enumerator(atPath: unitPath)
            
            while let note = enumerator?.nextObject() as? String {
                if note.hasSuffix("md") {
                    let notePath = "\(unitPath)/\(note)"
                    var content: String!
                    do {
                        content = try String(contentsOfFile: notePath, encoding: String.Encoding.utf8)
                    } catch {
                        print("ERR: GET NOTE CONTENT ISSUE")
                    }
                    let noteName = String(note.dropLast(3))
                    let sendToDatabase = Note(class: aClass, unit: unit, note: noteName, content: content!)
                    sendToDatabase.create(on: req)
                }
            }
        }
    }
}
