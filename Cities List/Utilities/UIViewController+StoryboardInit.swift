//
//  UIViewController+StoryboardInit.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit

extension UIViewController {
    class func initAsInitialFromStoryboard<T: UIViewController>(with type: T.Type, storyboard name: String = "\(T.self)") -> T {
        //swiftlint:disable:next force_cast
        let controller = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() as! T
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}
