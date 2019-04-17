//
//  ThingsNoteTableCell.swift
//  Things+
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

class ThingsNoteTableCell: UITableViewCell {
    
    var checkButtonClosure: VoidClosure?
    
    let customBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.white
        label.layer.cornerRadius = 10
        label.numberOfLines = 1
        label.backgroundColor = .clear
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.numberOfLines = 0
        return label
    }()
    
    let checkMark: UIButton = {
        let mark = UIButton()
        mark.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "squareRadioUncheck")
        let tintImage = image?.withRenderingMode(.alwaysTemplate)
        mark.setImage(tintImage, for: .normal)
        mark.isUserInteractionEnabled = true
        mark.tintColor = UIColor.white
        return mark
    }()
    
    var note: Note? = nil {
        didSet {
            guard let note = note else {
                return
            }
            
            self.categoryLabel.backgroundColor = note.category.categoryColor()
            self.titleLabel.text = String(note.content.split(separator: "\n")[0])
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            self.subtitleLabel.text = "Edited on \(formatter.string(from: note.lastEdited))"
            
            let checkImage = note.hasDone ? UIImage(named: "squareRadio") : UIImage(named: "squareRadioUncheck")
            self.checkMark.setImage(checkImage, for: .normal)
        }
    }
    
    static let identifier = "NoteTableCell"
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessibilityTraits = UIAccessibilityTraits.button
        
        self.fontSizeDidChange()
        NotificationCenter.default.addObserver(self, selector: #selector(fontSizeDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        
        self.contentView.addSubview(self.customBackgroundView)
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.contentView.addSubview(self.categoryLabel)
        self.addSubview(self.checkMark)
       
        self.checkMark.addTarget(self, action: #selector(checkClicked(_:)), for: .touchUpInside)
        contentView.isUserInteractionEnabled = false
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.customBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.customBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        self.customBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.readableContentGuide.leadingAnchor).isActive = true
        self.customBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.readableContentGuide.trailingAnchor).isActive = true
        
        self.checkMark.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.checkMark.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.checkMark.leadingAnchor.constraint(equalTo: self.customBackgroundView.leadingAnchor, constant: 5).isActive = true
        self.checkMark.centerYAnchor.constraint(equalTo:  self.customBackgroundView.centerYAnchor).isActive = true
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.checkMark.trailingAnchor, constant: 5).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.readableContentGuide.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        
        self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.subtitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        self.subtitleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor).isActive = true
        self.subtitleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        
        self.categoryLabel.topAnchor.constraint(equalTo: self.customBackgroundView.topAnchor).isActive = true
        self.categoryLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.categoryLabel.trailingAnchor.constraint(equalTo: self.customBackgroundView.trailingAnchor).isActive = true
        self.categoryLabel.bottomAnchor.constraint(equalTo: self.customBackgroundView.bottomAnchor).isActive = true
        
        self.bringSubviewToFront(checkMark)
        
    }
    
    @objc func checkClicked( _ sender: UIButton){
        checkButtonClosure?()
    }
    
    @objc func fontSizeDidChange() {
        if UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory {
            self.titleLabel.numberOfLines = 3
        } else {
            self.titleLabel.numberOfLines = 1
        }
    }
    
}
