//
//  EarthTip.swift
//  Things+
//
//  Created by Mai Nguyen on 3/31/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation


struct Tip {
    var title: String = ""
    var body: String = "" {
        didSet {
            imageString = title.components(separatedBy: ".").first ?? ""
        }
    }
    
    var imageString: String?
}
