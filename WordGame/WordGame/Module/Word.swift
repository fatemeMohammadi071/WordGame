//
//  Word.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

struct Word: Codable, Equatable {
    let english: String
    let spanish: String

    enum CodingKeys: String, CodingKey {
        case english = "text_eng"
        case spanish = "text_spa"
    }
}
