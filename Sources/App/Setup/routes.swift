//
//  routes.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    router.get(use: HomePageController().get)
    
    let notesController = NotesController()
    try router.register(collection: notesController)
    
    // TEMP: For Testing
    router.get("resetnotes") { req -> String in
        fillDatabase(req)
        return "Reset Notes"
    }
    
    router.get("favicon.ico") { req -> String in return "No Favicon Here" }
    router.get(String.parameter, use: ClassPageController().get)
    router.get(String.parameter, String.parameter, use: UnitPageController().get)
    router.get(String.parameter, String.parameter, String.parameter, use: NotePageController().get)
    
}
