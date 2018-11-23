//
//  Note.swift
//  App
//
//  Created by Liam on 11/18/18.
//

import Vapor
import FluentPostgreSQL

final class Note: Codable {
    var id: Int?
    var `class`: String
    var unit: String
    var note: String
    var content: String
    
    init(class: String, unit: String, note: String, content: String) {
        self.class   = `class`
        self.unit    = unit
        self.note    = note
        self.content = content
    }
    
    static let name = "note"
    static let entity = "notes"
}

extension Note: PostgreSQLModel { }

extension Note: Content { }

extension Note: PostgreSQLMigration { }

extension Note: Parameter { }
