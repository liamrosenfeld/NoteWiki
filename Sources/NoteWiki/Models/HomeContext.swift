//
//  HomeContext.swift
//  CHTTPParser
//
//  Created by Liam on 10/7/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

struct HomeContext: Codable {
    var classes: [Class]
}

struct `Class`: Codable {
    var name: String
    var link: String
}
