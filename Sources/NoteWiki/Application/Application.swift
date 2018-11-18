//
//  Application.swift
//  NoteWiki
//
//  Created by Liam on 9/30/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import LoggerAPI

public class App {
    let router = Router()

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }

    func postInit() throws {
        /* Possibly Retrieve Markdown Files from Server??? */
        initializeRoutes(app: self)
    }
}
