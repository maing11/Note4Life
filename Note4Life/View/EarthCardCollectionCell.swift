//
//  EarthCardCollectionCell.swift
//  Things+
//
//  Created by Larry Nguyen on 3/31/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class EarthCardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cardView: EarthCardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(earthTip: EarthTip) {
        self.layer.cornerRadius = self.height/2
        cardView.imageView.image = UIImage(named: earthTip.imageString ?? "1")
    }

}
