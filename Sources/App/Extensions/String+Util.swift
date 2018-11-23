//
//  String+Util.swift
//  NoteWiki
//
//  Created by Liam on 10/9/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) == true {
                return ($0 + " " + String($1))
            } else {
                return $0 + String($1)
            }
        }
    }
}
