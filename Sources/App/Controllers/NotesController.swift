//
//  NotesController.swift
//  NoteWiki
//
//  Created by Liam on 11/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor
import Fluent

final class NotesController: RouteCollection {
    func boot(router: Router) throws {
        let notesRoute = router.grouped("api", "notes")
        notesRoute.get(use: getAllHandler)
        notesRoute.post(use: createHandler)
        notesRoute.get(Note.parameter, use: getHandler)
        notesRoute.delete(use: deleteHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Note]> {
        return Note.query(on: req).all()
    }
    
    func createHandler(_ req: Request) throws -> Future<Note> {
        try auth(req)
        let note = try req.content.decode(Note.self)
        return note.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Note> {
        return try req.parameters.next(Note.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        try auth(req)
        let reqNote = try req.content.decode(Note.self)
        return reqNote.flatMap { note -> Future<Note?> in
            let className = note.class
            let unitName = note.unit
            let noteName = note.note
            return Note.query(on: req).filter(\.`class` == className).filter(\.unit == unitName).filter(\.note == noteName).first()
        }.flatMap { note -> Future<HTTPStatus> in
            guard let note = note else {
                throw Abort(.notFound)
            }
            return note.delete(on: req).transform(to: .noContent)
        }
    }
    
    func auth(_ req: Request) throws {
        let auth = req.http.headers.basicAuthorization
        guard let login = auth else {
            throw Abort(.forbidden)
        }
        
        if login.username != Environment.get("ADMIN_USERNAME") {
            throw Abort(.forbidden)
        }
        if login.password != Environment.get("ADMIN_PASSWORD") {
            throw Abort(.forbidden)
        }
    }
    
}
