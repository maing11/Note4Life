//
//  AppColor.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/29/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

struct AppConstant {
    struct Palette {
        static let skyfall = "75CDD8"
        static let orange = "F99304"
        static let pinky = "FF8296"
        static let tokenOrange = "F9404E"
        static let sunrise = "FFEC00"
        static let greenBlue = "00BFAE"
        static let littleGreen = "769E52"
        static let skinBlue = "84B7D2"
    }
}

enum ThemeColor {
    case today
    case thisWeek
    case anytime
    case goals
    case projects
    case all
    case needHelp
    case custom(hexString: String, alpha: Double)
    
    func alpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension ThemeColor {
    
    var value: UIColor {
        var color = AppConstant.Palette.greenBlue.color
    
        return color
    }
}

