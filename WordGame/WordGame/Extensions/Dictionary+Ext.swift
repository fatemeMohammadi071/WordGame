//
//  Dictionary+Ext.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

extension Dictionary {
    mutating func swap(key1: Key, key2: Key) {
        if  let value = self[key1], let existingValue = self[key2] {
            self[key1] = existingValue
            self[key2] = value
        }

    }
}
