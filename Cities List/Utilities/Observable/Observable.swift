//
//  Observable.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

protocol Observable: AnyObject {
    func subscribe(with observer: Observer)
    func unsubscribe(with observer: Observer)
}

class ObservableType: Observable {
    private(set) var observations = [Observation]()
    func postUpdateToObservers() {
        observations.compactObservers()
        observations.forEach { $0.observer?.didUpdate(self) }
    }
    func postErrorToObservers(error: Error) {
        observations.compactObservers()
        observations.forEach { $0.observer?.didError(error) }
    }
    func subscribe(with observer: Observer) {
        observations.append(observer: observer)
    }
    func unsubscribe(with observer: Observer) {
        observations.remove(observer: observer)
    }
}
