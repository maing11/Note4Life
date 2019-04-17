//
//  AppTheme.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import UIKit

class NoteTheme {
    
    static var backgroundColor: UIColor {
        return UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
    }
    
    static var logoImage: UIImage {
        return UIImage(named: "ThingPlus")!
    }
    
    static var onboardingColors: [UIColor] {
        return [ UIColor.init(hexString: "#E3493B"),UIColor.init(hexString: "#EEBA4C"), UIColor.black]
    }
    
    static var onboardingInfoImages: [UIImage] {
        return [UIImage(named: "earthInfo1")!.tint(), UIImage(named: "earthInfo2")!.tint(), UIImage(named: "earthInfo3")!.tint(), UIImage(named: "earthInfo4")!.tint()]
    }
    
    static var onboardingPageIcons: [UIImage] {
        return [UIImage(named: "animal1")!.tint(),UIImage(named: "animal2")!.tint(),UIImage(named: "animal3")!.tint(),UIImage(named: "animal4")!.tint()]
    }
    
    static var descArray: [String] {
        let a1: String = "I believe that using digital note helps THE EARTH tremendously"
        let a2: String = "I think many simple things we do affect THE EARTH in negative ways, And the app includes some of the tips to turn it around."
        let a3: String = "Tell me if the tips are really helpful "
        
        return [a1,a2,a3]
    }
    
    static var titleArray: [String] {
        let a1: String = "DIGITAL NOTE"
        let a2: String = "SAVE THE EARTH TIPS"
        let a3: String = "THE KINDNESS OF YOU"
        
        return [a1,a2,a3]
    }
}

