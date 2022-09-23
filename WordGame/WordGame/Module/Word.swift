//
//  Word.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

struct Word: Codable, Hashable {
    let english: String
    var spanish: String

    enum CodingKeys: String, CodingKey {
        case english = "text_eng"
        case spanish = "text_spa"
    }
}
