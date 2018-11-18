//
//  main.swift
//  NoteWiki
//
//  Created by Liam on 9/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import HeliumLogger
import LoggerAPI

do {
    HeliumLogger.use(LoggerMessageType.info)
    let app = App()
    try app.run()
} catch let error as InitializationError {
    Log.error(error.localizedDescription)
}
