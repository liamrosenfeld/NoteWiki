//
//  NotFound.swift
//  NoteWiki
//
//  Created by Liam on 10/7/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Kitura
import LoggerAPI

func showNotFoundPage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void ) {
    do {
        let path = StaticFileServer(path: "public/404.html").absoluteRootPath
        try response.send(fileName: path)
    } catch let error {
        response.status(.internalServerError).send(error.localizedDescription)
    }
}
