//
//  EarthTip.swift
//  Things+
//
//  Created by Larry Nguyen on 3/31/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation


struct EarthTip {
    var title: String = ""
    var body: String = "" {
        didSet {
            imageString = title.components(separatedBy: ".").first ?? ""
        }
    }
    
    var imageString: String?
}
