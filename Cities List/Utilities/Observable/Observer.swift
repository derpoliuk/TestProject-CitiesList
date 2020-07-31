//
//  Observer.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

protocol Observer: AnyObject {
    func didUpdate<T: Observable>(_ viewModel: T)
    func didError(_ error: Error)
}
