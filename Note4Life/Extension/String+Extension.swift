//
//  String+Extension.swift
//  Things+
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

extension String {
    
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
}


extension String {
    public var color: UIColor {
        return UIColor(hexString: self)
    }
    
    public var image: UIImage? {
        return UIImage(named: self)
    }
}


