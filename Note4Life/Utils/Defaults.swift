//
//  Defaults.swift
//  Things+
//
//  Created by Larry Nguyen on 4/2/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation

struct Defaults {
    
    static let firstTimeOpenKey = "firstTimeOpen"
    static let userSessionKey = "com.save.usersession"
    
    struct DefaultModel {
        var firstTimeOpen: Bool = true
        
        init(_ json: [String: Any]) {
            if json.count == 0 {return}
            self.firstTimeOpen  = json[firstTimeOpenKey] as! Bool
        }
    }
    
    static var saveFirstTimeOpenBool = { (firstOpen: Bool) in
        UserDefaults.standard.set([firstTimeOpenKey: firstOpen], forKey: userSessionKey)
    }
    
    static var getUserFirstOpenStatus = { _ -> DefaultModel in
        return DefaultModel((UserDefaults.standard.value(forKey: userSessionKey) as? [String: Any]) ?? [:])
    }(())
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: userSessionKey)
    }
}
