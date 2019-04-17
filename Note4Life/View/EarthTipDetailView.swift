//
//  EarthTipDetailView.swift
//  Things+
//
//  Created by Larry Nguyen on 3/31/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

import UIKit

class EarthTipDetailView: UIView {
    
    weak var visibleTipView: VisibleTipView!
    weak var bodyContentLabel: UILabel!
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = UIColor.black
        self.cornerRadius = 12
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupVisibleTipView()
        setupContentLabel()
    }
    
    
    private func setupVisibleTipView() {
        
        let view = VisibleTipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.visibleTipView = view
    }
    
    private func setupContentLabel(){
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.textColor  = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        self.addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive  = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        label.topAnchor.constraint(equalTo: visibleTipView.bottomAnchor).isActive = true

        self.bodyContentLabel = label
    }


    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

