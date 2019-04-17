//
//  JSONFactory.swift
//  Things+
//
//  Created by Larry Nguyen on 3/29/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import NotificationCenter

class EarthTipsFactory {
    static func readJson(fileName: String, completion: @escaping ([EarthTip]) -> () ) {
        
        var earthTips = [EarthTip]()
        DispatchQueue.global().async {
            do {
                if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let _ = json as? [String: Any] {
                        // json is a dictionary
                        
                    } else if let object = json as? [Any] {
                        // json is an array
                        for obj in object {
                            guard let obj = obj as? [String: String] else {return}
                            let title = obj["title"]
                            let body = obj["body"]
                            var tip = EarthTip()
                            tip.title = title ?? ""
                            tip.body = body ?? ""
                            earthTips.append(tip)
                        }
                        print("Number of earth tips: \(earthTips)")
                        completion(earthTips)
    
                    } else {
                        print("Invalid JSON")
                        completion(earthTips)
                    }
                } else {
                    print("File Not Found")
                     completion(earthTips)
                }
            } catch {
                print(error.localizedDescription)
                completion(earthTips)
            }
        }
    }
}
