//
//  Note.swift
//  App
//
//  Created by Liam on 11/18/18.
//

import Vapor
import Foundation

struct Note: Content {
    var `class`: String
    var unit: String
    var name: String
    var content: String
}
