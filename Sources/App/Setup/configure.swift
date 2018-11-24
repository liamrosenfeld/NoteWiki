//
//  configure.swift
//  NoteWiki
//
//  Created by Liam on 11/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Vapor
import Leaf
import FluentPostgreSQL

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
    
    // Add Leaf Tags
    services.register { container -> LeafTagConfig in
        var config = LeafTagConfig.default()
        config.use(Raw(), as: "raw")
        return config
    }
    
    // Setup Middlewear
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    // Setup PostgreSQL Database
    try services.register(FluentPostgreSQLProvider())
    var databases = DatabasesConfig()
    let databaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url, transport: .unverifiedTLS)!
    } else {
        databaseConfig = try PostgreSQLDatabaseConfig.default()
    }
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    // Setup Database Migration
    var migrations = MigrationConfig()
    migrations.add(model: Note.self, database: .psql)
    services.register(migrations)
    
}
