//
//  String+Ext.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

@objc extension NSString {
    func convertStringToDictionary() -> [String: Any] {
        var dictonary: [String: Any]?
        if let data = self.data(using: String.Encoding.utf8.rawValue) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let myDictionary = dictonary {
                    return myDictionary
                }
            } catch {
                return [:]
            }
        }
        return dictonary ?? [:]
    }
}
