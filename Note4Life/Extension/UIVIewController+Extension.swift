//
//  UIVIewController+Extension.swift
//  Things+
//
//  Created by Larry Nguyen on 3/31/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
          
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
