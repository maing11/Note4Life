//
//  Category.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit


enum Category: Int {
    case Today = 0
    case ThisWeek = 1
    case Anytime = 2
    case ThisYearGoal = 3
    case NeedHelp = 4
    case Project = 5
    case All = 6
    
    static func allCategories() -> [Category] {
        return [Category.Today, Category.ThisWeek, Category.Anytime, Category.ThisYearGoal, Category.NeedHelp, Category.Project, Category.All]
    }
}

extension Category {
    func categoryImageName() -> String{
        switch self {
        case .Today:
            return "icons8-today"
        case .ThisWeek:
            return "icons8-calendar_plus"
        case .ThisYearGoal:
            return "icons8-goal"
        case .Anytime:
            return "icons8-bread"
        case .Project:
            return "icons8-presentation"
        case .NeedHelp:
            return "icons8-online_support"
        case .All:
            return "icons8-check_all"
            
        }
    }
    
    func categoryBackgroundImageName() -> String{
        switch self {
        case .Today:
            return "today"
        case .ThisWeek:
            return "thisweek"
        case .ThisYearGoal:
            return "goals"
        case .Anytime:
            return "anytime"
        case .Project:
            return "project"
        case .NeedHelp:
            return "needHelp"
        case .All:
            return "all"
        }
    }
    
    
    func categoryName() -> String {
        switch self {
        case .Today:
            return "Groceries"
        case .ThisWeek:
            return "Work"
        case .ThisYearGoal:
            return "Appointment"
        case .Anytime:
            return "Family"
        case .Project:
            return "Home"
        case .NeedHelp:
            return "Whatever"
        case .All:
            return "All Notes"
        }
    }
    
    func categoryColor() -> UIColor {
        switch self {
        case .Today:
            return AppColor.today.value
        case .ThisWeek:
            return AppColor.thisWeek.value
        case .ThisYearGoal:
            return AppColor.goals.value
        case .Anytime:
            return AppColor.anytime.value
        case .Project:
            return AppColor.projects.value
        case .NeedHelp:
            return AppColor.needHelp.value
        case .All:
            return AppColor.all.value
        }
    }
}
