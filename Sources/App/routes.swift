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
    
    router.get(use: HomeController().get)
    
    router.get("favicon.ico") { req -> String in
        return "No Favicon Here"
    }
    
    router.get(String.parameter, use: ClassController().get)
    router.get(String.parameter, String.parameter, use: UnitController().get)
    router.get(String.parameter, String.parameter, String.parameter, use: NoteController().get)
}
