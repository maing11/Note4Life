//
//  EarthCardCollectionCell.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/31/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

class EarthCardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cardView: TipView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(earthTip: Tip) {
        self.layer.cornerRadius = self.height/2
        cardView.imageView.image = UIImage(named: earthTip.imageString ?? "1")
    }

}
