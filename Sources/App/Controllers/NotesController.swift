//
//  NotesController.swift
//  NoteWiki
//
//  Created by Liam on 11/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor

final class NotesController: RouteCollection {
    func boot(router: Router) throws {
        let notesRoute = router.grouped("api", "notes")
        notesRoute.get(use: getAllHandler)
        notesRoute.post(use: createHandler)
        notesRoute.get(Note.parameter, use: getHandler)
        notesRoute.delete(Note.parameter, use: deleteHandler)
        notesRoute.put(Note.parameter, use: updateHandler)
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
        
        return try req.parameters.next(Note.self).flatMap(to: HTTPStatus.self) { note in
            return note.delete(on: req).transform(to: .noContent)
        }
    }
    
    func updateHandler(_ req: Request) throws -> Future<Note> {
        try auth(req)
        
        return try flatMap(to: Note.self, req.parameters.next(Note.self), req.content.decode(Note.self)) { note, updatedNote in
            note.class = updatedNote.class
            note.unit = updatedNote.unit
            note.note = updatedNote.note
            note.content = updatedNote.content
            return note.save(on: req)
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
