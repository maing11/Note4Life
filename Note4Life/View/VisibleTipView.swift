//
//  VisibleTipView.swift
//  Things+
//
//  Created by Larry Nguyen on 3/31/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class VisibleTipView: UIView {

    @IBOutlet weak var drawerHandle: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewLabel: UILabel!
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
