//
//  AppColor.swift
//  Things+
//
//  Created by Larry Nguyen on 3/29/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

struct SPConstants {
    struct ColorPaletteHex {
        static let skyBlue = "75CDD8"
        static let orange = "F99304"
        static let lightPink = "FF8296"
        static let graphFruit = "F9404E"
        static let morningSun = "FFEC00"
        static let greenBlue = "00BFAE"
        static let fauxGreen = "769E52"
        static let waterBlue = "84B7D2"
    }
}

enum AppColor {
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

extension AppColor {
    
    var value: UIColor {
        var color = UIColor.clear
        
        switch self {
        case .today:
            color = SPConstants.ColorPaletteHex.skyBlue.color
        case .thisWeek:
            color = SPConstants.ColorPaletteHex.orange.color
        case .anytime:
            color = SPConstants.ColorPaletteHex.lightPink.color
        case .projects:
            color = SPConstants.ColorPaletteHex.graphFruit.color
        case .goals:
            color = SPConstants.ColorPaletteHex.greenBlue.color
        case .needHelp:
            color = SPConstants.ColorPaletteHex.fauxGreen.color
        case .all:
            color = SPConstants.ColorPaletteHex.waterBlue.color
    
        case .custom(let hexValue, let opacity):
            color = hexValue.color.withAlphaComponent(CGFloat(opacity))
        }
        
        return color
    }
}

