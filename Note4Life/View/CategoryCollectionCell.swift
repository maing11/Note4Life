//
//  CategoryCollectionCell.swift
//  Things+
//
//  Created by Larry Nguyen on 3/28/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    var actionButtonClosure: VoidClosure?

    var category: Category? = nil {
        didSet {
            guard let category = category else {
                return
            }
            
            
            
            self.categoryView.mainImageView.image = UIImage(named: category.categoryBackgroundImageName())
            self.categoryView.titleLabel.text = category.categoryName()
            self.categoryView.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.categoryView.titleLabel.tintColor = .white
            
            let origImage = UIImage(named:category.categoryImageName())
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            
            self.categoryView.categoryImageView.image = tintedImage
            self.categoryView.actionButton.tintColor = .white
            self.categoryView.actionButton.backgroundColor = category.categoryColor()
            self.categoryView.countLabel.layer.cornerRadius = self.categoryView.countLabel.height/2
            
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.categoryView.bottomView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.categoryView.bottomView.insertSubview(blurEffectView, at: 0)
            
            self.categoryView.actionButton.layer.cornerRadius = self.categoryView.actionButton.frame.height/2
            self.categoryView.actionButton.tintColor = .white
            self.categoryView.actionButton.addTarget(self, action: #selector(actionButtonClick(_:)), for: .touchUpInside)
            
            self.categoryView.categoryImageView.tintColor = category.categoryColor()
            self.bringSubviewToFront(self.categoryView.actionButton)
            self.bringSubviewToFront(self.categoryView.categoryImageView)
            
            layoutIfNeeded()
            
        }
    }
    
    let categoryView: CategoryView = {
        let view = CategoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    static let identifier = "CategoryCollectionCell"
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.accessibilityTraits = UIAccessibilityTraits.button
        
        self.contentView.addSubview(self.categoryView)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.categoryView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.categoryView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.categoryView.leadingAnchor.constraint(equalTo: self.contentView.readableContentGuide.leadingAnchor).isActive = true
        self.categoryView.trailingAnchor.constraint(equalTo: self.contentView.readableContentGuide.trailingAnchor).isActive = true
    }
    
    @objc private func actionButtonClick(_ sender: UIButton){
        self.actionButtonClosure?()
    }
    
}
