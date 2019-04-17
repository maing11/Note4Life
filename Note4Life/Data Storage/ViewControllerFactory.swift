//
//  ViewControllerFactory.swift
//  Things+
//
//  Created by Larry Nguyen on 4/2/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerFactor {
    static func createViewControler(in storyboardName: String, id: String) -> UIViewController {
        let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        return vc
    }
}
