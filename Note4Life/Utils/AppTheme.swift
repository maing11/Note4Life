//
//  AppTheme.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation
import UIKit

class NoteTheme {
    
    static var backgroundColor: UIColor {
        return UIColor.white
    }
    
    static var logoImage: UIImage {
        return UIImage(named: "ThingPlus")!
    }
    
    static var onboardingColors: [UIColor] {
        return [ UIColor.black ,UIColor.orange, UIColor.blue]}
    
    static var onboardingInfoImages: [UIImage] {
        return [UIImage(named: "earthInfo1")!.tint(), UIImage(named: "earthInfo2")!.tint(), UIImage(named: "earthInfo3")!.tint()]
    }
    
    static var onboardingPageIcons: [UIImage] {
        return []
    }
    
    static var descArray: [String] {
        let a1: String = "Just Note It"
        let a2: String = "Write Something Sometimes"
        let a3: String = "There Are Some Tips On Productity"
        
        return [a1,a2,a3]
    }
    
    static var titleArray: [String] {
        let a1: String = "Note For Life"
        let a2: String = "Use Note to Save Paper"
        let a3: String = "Lets Write Your First Note"
        
        return [a1,a2,a3]
    }
}

