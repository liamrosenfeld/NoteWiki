//
//  InitializationError.swift
//  NoteWiki
//
//  Created by Liam on 10/7/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

public struct InitializationError: Error {
    let message: String
    init(_ msg: String) {
        message = msg
    }
}

// MARK: - LocalizedError

extension InitializationError: LocalizedError {
    public var errorDescription: String? {
        return message
    }
}
