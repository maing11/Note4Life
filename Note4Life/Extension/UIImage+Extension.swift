//
//  UIImage+Extension.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/29/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scale(to newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / self.size.width
        let verticalRatio = newSize.height / self.size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        var newImage: UIImage
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image { (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), false, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
    
    func tint() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

