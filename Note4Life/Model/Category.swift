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
    case Plan = 2
    case Grocery = 3
    case Tips = 4
    case Goals = 5
    case All = 6
    
    static func allCategories() -> [Category] {
        return [Category.Work, Category.Home, Category.Plan, Category.Grocery, Category.Tips, Category.Goals, Category.All]
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
        case .Plan:
            return "icons8-bread"
        case .Goals:
            return "icons8-presentation"
        case .Tips:
            return "icons8-online_support"
        case .All:
            return "icons8-check_all"
            
        }
    }
    
    func categoryBackgroundImageName() -> String{
        switch self {
        case .Work:
            return "c1"
        case .Home:
            return "c2"
        case .Grocery:
            return "c3"
        case .Plan:
            return "c4"
        case .Goals:
            return "c5"
        case .Tips:
            return "c6"
        case .All:
            return "c7-1"
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
        case .Plan:
            return "Plan"
        case .Goals:
            return "Goals"
        case .Tips:
            return "Tips"
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
        case .Plan:
            return ThemeColor.anytime.value
        case .Goals:
            return ThemeColor.projects.value
        case .Tips:
            return ThemeColor.needHelp.value
        case .All:
            return ThemeColor.all.value
        }
    }
}
