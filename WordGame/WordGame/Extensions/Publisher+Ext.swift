//
//  Publisher+Ext.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation
import Combine

extension Publisher {
    func guaranteeMainThread() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
