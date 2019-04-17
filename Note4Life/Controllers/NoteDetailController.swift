//
//  NoteDetailController.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//


import UIKit

class NoteDetailController: UIViewController {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.adjustsFontForContentSizeCategory = true
        textView.textColor = UIColor.white
        textView.text = "..."
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.white
        textView.dataDetectorTypes = .all
        textView.tintColor = UIColor.gray
        return textView
    }()
    
    let backGroundTextView: UnderlinedTextView = {
        let textView = UnderlinedTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.adjustsFontForContentSizeCategory = true
        textView.textColor = UIColor.white
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.dataDetectorTypes = .all
        textView.tintColor = UIColor.gray
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let changeCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.sizeToFit()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showAlert(_:)), for: .touchUpInside)
        return button
    }()
    
    var note: Note? = nil
    var category: Category  = .Work
    let placeholder = "Write you note here"
    
    var originalContent: String = ""
    var shouldDelete: Bool = false
    
    var doneButton: UIBarButtonItem? = nil
    var trashButton: UIBarButtonItem? = nil
    
    let realmDataPersistence: RealmDataPersistence
    
    init(realmDataPersistence: RealmDataPersistence, category: Category) {
        self.realmDataPersistence = realmDataPersistence
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = category.categoryName().capitalized
        self.view.backgroundColor = NoteTheme.backgroundColor
        self.navigationItem.largeTitleDisplayMode = .never
        
        if self.note == nil {
            self.note = Note(content: "")
            self.note?.category = self.category
            self.changeCategoryButton.backgroundColor = self.category.categoryColor()
            self.changeCategoryButton.setTitle(self.category.categoryName(), for: .normal)
        }
        
        self.originalContent = self.note?.content ?? ""
        
        self.view.addSubview(self.changeCategoryButton)
        self.view.addSubview(self.textView)
        self.view.addSubview(self.backGroundTextView)
        
        self.changeCategoryButton.topAnchor.constraint(equalTo: self.view.readableContentGuide.topAnchor, constant: 10).isActive = true
        self.changeCategoryButton.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        self.changeCategoryButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.changeCategoryButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.changeCategoryButton.layer.cornerRadius = 15
        
        self.textView.topAnchor.constraint(equalTo: self.changeCategoryButton.bottomAnchor).isActive = true
        self.textView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.textView.text = self.note?.content.isEmpty == true ? self.placeholder : self.note?.content
        self.textView.tintColor = UIColor.lightGray
        
        self.backGroundTextView.topAnchor.constraint(equalTo: self.changeCategoryButton.bottomAnchor).isActive = true
        self.backGroundTextView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        self.backGroundTextView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor).isActive = true
        self.backGroundTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.textView.text = self.note?.content.isEmpty == true ? self.placeholder : self.note?.content
        self.textView.tintColor = UIColor.lightGray
        self.textView.delegate = self
        
        self.doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        self.trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
        
        if let trashButton = self.trashButton {
            self.navigationItem.rightBarButtonItems = [trashButton]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func didTapDone() {
        self.textView.endEditing(true)
        StoreReviewHelper.checkAndAskForReview()
        
    }
    
    @objc func didTapDelete() {
        self.shouldDelete = true
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.textView.text.isEmpty || self.shouldDelete || self.textView.text == placeholder {
            self.note?.delete(dataSource: self.realmDataPersistence)
        } else {
            // Ensure that the content of the note has changed.
            guard self.originalContent != self.note?.content else {
                return
            }
            
            self.note?.write(dataSource: self.realmDataPersistence)
        }
    }
    
    
    @objc private func showAlert(_ sender: UIButton) {
        let alertController = MyAlertController(title: "Pick Category", message: "😀🌵🐚🍋", preferredStyle: .alert)
        
        for category in Category.allCategories() {
            let origImage = UIImage(named:category.categoryImageName())
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)

            let categoryAction = UIAlertAction(title: category.categoryName(), style: .default, image: tintedImage){ _ in
                self.category = category
                self.note?.category = category
                self.changeCategoryButton.backgroundColor = self.category.categoryColor()
                self.changeCategoryButton.setTitle(self.category.categoryName(), for: .normal)
                self.changeCategoryButton.titleLabel?.sizeToFit()
                self.navigationItem.title = category.categoryName()
            }
          
            categoryAction.titleTextColor = category.categoryColor()
            alertController.addAction(categoryAction)
            
        }
       
        alertController.addAction(title: "Cancel", style: .cancel)
        
        alertController.addParallaxEffect(x: 10, y: 10)
        self.present(alertController, animated: true)
    
        alertController.titleAttributes += [
            StringAttribute(key: .foregroundColor, value: category.categoryColor())
        ]
    }
}

extension NoteDetailController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholder {
            textView.text = ""
        }
        
        self.navigationItem.hidesBackButton = true
        
        if let trashButton = self.trashButton, let doneButton = self.doneButton {
            self.navigationItem.rightBarButtonItems = [doneButton, trashButton]
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholder
        }
        
        self.note?.content = textView.text
        
        if let trashButton = self.trashButton {
            self.navigationItem.rightBarButtonItems = [trashButton]
        }
        
        self.navigationItem.hidesBackButton = false
    }
    
}


class UnderlinedTextView: UITextView {
    var lineHeight: CGFloat = 13.8
    
    override var font: UIFont? {
        didSet {
            if let newFont = font {
                lineHeight = newFont.lineHeight
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setStrokeColor(UIColor.black.cgColor)
        let numberOfLines = Int(rect.height / lineHeight)
        let topInset = textContainerInset.top
        
        for i in 1...numberOfLines {
            let y = topInset + CGFloat(i) * lineHeight
            
            let line = CGMutablePath()
            line.move(to: CGPoint(x: 0.0, y: y))
            line.addLine(to: CGPoint(x: rect.width, y: y))
            ctx?.addPath(line)
        }
        
        ctx?.strokePath()
        
        super.draw(rect)
    }
}
