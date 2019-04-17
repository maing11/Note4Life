//
//  StoryboardProtocol.swift
//  Note4Life
//
//  Created by Mai Nguyen on 4/2/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardProtocol: class {
    static var storyboardName: String { get }
}

extension StoryboardProtocol where Self: UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static func storyboardViewController<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? T else {
            fatalError("failed to instantiate initial storyboard with name: \(T.storyboardName)")
        }
        
        return vc
    }
}

extension UIViewController: StoryboardProtocol { }
