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
        textView.textColor = UIColor.black
        textView.text = "..."
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.backgroundColor = NoteTheme.backgroundColor
        textView.dataDetectorTypes = .all
        textView.tintColor = UIColor.gray
        return textView
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
        }
        
        self.originalContent = self.note?.content ?? ""
        
      
        self.view.addSubview(self.textView)
       
        
        
        self.textView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.textView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.textView.text = self.note?.content.isEmpty == true ? self.placeholder : self.note?.content
        self.textView.tintColor = UIColor.lightGray
        
        
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
