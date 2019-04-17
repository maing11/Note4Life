//
//  TipView.swift
//  Things+
//
//  Created by Mai Nguyen on 3/31/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

class TipView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        contentView.pinch(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        
    }

}
