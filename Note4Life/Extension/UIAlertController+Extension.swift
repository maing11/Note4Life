//
//  UIAlertController+Extension.swift
//  Things+
//
//  Created by Larry Nguyen on 3/29/19.
//  Copyright © 2019 Larry. All rights reserved.
//


import UIKit

extension UIAlertController {
    func addAction(title: String, style: UIAlertAction.Style = .default, image: UIImage? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        self.addAction(UIAlertAction(title: title, style: style, image: image, handler: handler))
    }
}

extension UIAlertAction {
    convenience init(title: String, style: UIAlertAction.Style = .default, image: UIImage?, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        if let image = image {
            self.accessoryImage = image
        }
    }
}

