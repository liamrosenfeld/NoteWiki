//
//  Routes.swift
//  NoteWiki
//
//  Created by Liam on 9/30/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import KituraStencil
import LoggerAPI

func initializeRoutes(app: App) {
    app.router.setDefault(templateEngine: StencilTemplateEngine())
    app.router.get("/", handler: showHomePage)
    app.router.get("/404", handler: showNotFoundPage)
    app.router.get("/:class", handler: showClassPage)
    app.router.get("/:class/:unit", handler: showUnitPage)
    app.router.get("/:class/:unit/:note", handler: showNotePage)
    Log.info("Routes created")
}
