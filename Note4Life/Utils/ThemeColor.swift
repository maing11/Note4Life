//
//  AppColor.swift
//  Things+
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
        var color = UIColor.clear
        
        switch self {
        case .today:
            color = AppConstant.Palette.skyfall.color
        case .thisWeek:
            color = AppConstant.Palette.orange.color
        case .anytime:
            color = AppConstant.Palette.pinky.color
        case .projects:
            color = AppConstant.Palette.tokenOrange.color
        case .goals:
            color = AppConstant.Palette.greenBlue.color
        case .needHelp:
            color = AppConstant.Palette.littleGreen.color
        case .all:
            color = AppConstant.Palette.skinBlue.color
    
        case .custom(let hexValue, let opacity):
            color = hexValue.color.withAlphaComponent(CGFloat(opacity))
        }
        
        return color
    }
}

