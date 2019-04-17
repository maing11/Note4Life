//
//  Category.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit


enum Category: Int {
    case Work = 0
    case Home = 1
    case Appoitment = 2
    case Grocery = 3
    case Fun = 4
    case Resolution = 5
    case All = 6
    
    static func allCategories() -> [Category] {
        return [Category.Work, Category.Home, Category.Appoitment, Category.Grocery, Category.Fun, Category.Resolution, Category.All]
    }
}

extension Category {
    func categoryImageName() -> String{
        switch self {
        case .Work:
            return "icons8-today"
        case .Home:
            return "icons8-calendar_plus"
        case .Grocery:
            return "icons8-goal"
        case .Appoitment:
            return "icons8-bread"
        case .Resolution:
            return "icons8-presentation"
        case .Fun:
            return "icons8-online_support"
        case .All:
            return "icons8-check_all"
            
        }
    }
    
    func categoryBackgroundImageName() -> String{
        switch self {
        case .Work:
            return "work"
        case .Home:
            return "home"
        case .Grocery:
            return "grocery"
        case .Appoitment:
            return "appointment"
        case .Resolution:
            return "resolution"
        case .Fun:
            return "func"
        case .All:
            return "all"
        }
    }
    
    
    func categoryName() -> String {
        switch self {
        case .Work:
            return "Work"
        case .Home:
            return "Home"
        case .Grocery:
            return "Grocery"
        case .Appoitment:
            return "Appoitment"
        case .Resolution:
            return "Resolution"
        case .Fun:
            return "Fun"
        case .All:
            return "All Notes"
        }
    }
    
    func categoryColor() -> UIColor {
        switch self {
        case .Work:
            return ThemeColor.today.value
        case .Home:
            return ThemeColor.thisWeek.value
        case .Grocery:
            return ThemeColor.goals.value
        case .Appoitment:
            return ThemeColor.anytime.value
        case .Resolution:
            return ThemeColor.projects.value
        case .Fun:
            return ThemeColor.needHelp.value
        case .All:
            return ThemeColor.all.value
        }
    }
}
