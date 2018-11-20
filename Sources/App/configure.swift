//
//  configure.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor
import Leaf
import FluentSQLite

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register Leaf
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    // Add Tags
    services.register { container -> LeafTagConfig in
        var config = LeafTagConfig.default()
        config.use(Raw(), as: "raw")
        
        return config
    }
    
    // Setup SQL TEMP
    try services.register(FluentSQLiteProvider())
    let sqlite = try SQLiteDatabase(storage: .memory)
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
}
