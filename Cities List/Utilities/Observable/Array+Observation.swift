//
//  Array+Observation.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

extension Array where Element == Observation {
    mutating func compactObservers() {
        self = filter { $0.observer != nil }
    }

    mutating func append(observer: Observer) {
        append(Observation(observer: observer))
    }

    mutating func remove(observer: Observer) {
        if let index = firstIndex(where: { $0.observer === observer }) {
            remove(at: index)
        }
    }
}
