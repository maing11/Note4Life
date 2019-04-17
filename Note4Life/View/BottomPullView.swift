//
//  BottomPullView.swift
//  Things+
//
//  Created by Larry Nguyen on 3/31/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

protocol EarthTipSelectProtocol {
    func didSelectEarthTip(tip: EarthTip)
    func didSelectImages(count: Int, images: [UIImage])
}

enum BottomPullViewState {
    case earthTip
    case upgrade
}

class BottomPullView: UIView {
    
    var state: BottomPullViewState {
        didSet {
            self.layoutSubviews()
        }
    }
    
    private let collectionCellName = "EarthCardCollectionCell"
    private let collectionCellId = "collectionCellId"
    
    var earthTips: [EarthTip] {
        didSet {
            if !earthTips.isEmpty {
                let random = Int.random(in: 1...(earthTips.count - 1))
                showedTip = self.earthTips[random]
                NotificationCenter.default.post(name: .earthJsonLoaded, object: nil)
            }
        }
    }
    
    var delegate: EarthTipSelectProtocol?
    var showedTip: EarthTip?

    private var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        return layout
    }()
    
    private(set) weak var collectionView: UICollectionView!
    private(set) weak var visibleTipView: VisibleTipView!
    
    private let bottomBarAnimation = CABasicAnimation(keyPath: "yPosition")
    
    private var stopAnimation = false
    
    override init(frame: CGRect) {
        earthTips = []
        state = .earthTip
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(doneJsonLoading), name: .earthJsonLoaded, object: nil)
        
        EarthTipsFactory.readJson(fileName: "earth", completion: { [weak self] earthTips in
            self?.earthTips = earthTips
        })
        
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
        setupCollectionView()
        
        setupAnimation()
        
    }
    
    private func setupCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        let collectionViewCellNib = UINib(nibName:collectionCellName, bundle: nil)
        collectionView.register(collectionViewCellNib, forCellWithReuseIdentifier: collectionCellId)
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentOffset.x = 10
        collectionView.contentInset.left = 0
        collectionView.contentInset.right = 0
        
        collectionView.setNeedsUpdateConstraints()
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: visibleTipView.bottomAnchor).isActive = true
        let collectionHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        collectionHeightConstraint.priority = .defaultHigh
        collectionHeightConstraint.isActive = true
        
        self.collectionView = collectionView
    }
    
    @objc func doneJsonLoading(){
        mainQueue {
            self.collectionView.reloadData()
            self.layoutSubviews()
        }
    }
    
    private func setupVisibleTipView() {
        
        let view = VisibleTipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(notifyEarthTipPop))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        self.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.visibleTipView = view
    }
    
    private func setupAnimation() {
        bottomBarAnimation.isAdditive  = true
        bottomBarAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 3))
        bottomBarAnimation.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: -3))
        bottomBarAnimation.autoreverses = true
        bottomBarAnimation.duration = 1.7
        bottomBarAnimation.repeatCount = Float.infinity
    }
    
    func suspendAnimation(){
        visibleTipView.drawerHandle.layer.removeAllAnimations()
        stopAnimation = true
    }
    
    @objc func notifyEarthTipPop( _ sender: Any){
        guard let tip = showedTip else {return}
        delegate?.didSelectEarthTip(tip: tip)
    }
    
    override func layoutSubviews() {
        mainQueue {
//            if self.state == .earthTip {
//                let imageString = self.showedTip?.imageString ?? "1"
//                self.visibleTipView.imageView.image = UIImage(named: (imageString + ".png"))
//                self.visibleTipView.viewLabel.text = self.showedTip?.title ?? ""
//            } else if self.state == .upgrade {
//                self.visibleTipView.imageView.image = UIImage(named:"all")
//                self.visibleTipView.imageView.cornerRadius = self.visibleTipView.imageView.frame.height/2
//                self.visibleTipView.viewLabel.text = "UPGRADE TO KIND EDITION"
//            }
//            
            let imageString = self.showedTip?.imageString ?? "1"
            self.visibleTipView.imageView.image = UIImage(named: (imageString + ".png"))
            self.visibleTipView.viewLabel.text = self.showedTip?.title ?? ""
   
            
            super.layoutSubviews()
            if !self.stopAnimation{
                self.visibleTipView.drawerHandle.layer.add(self.bottomBarAnimation, forKey: "bottomBarAnimation" )
            }
        }

    }
    
}

extension BottomPullView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectEarthTip(tip: earthTips[indexPath.row])
    }
}

extension BottomPullView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return earthTips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath) as? EarthCardCollectionCell {
            let thisTip = self.earthTips[indexPath.row]
            cell.setupView(earthTip: thisTip)
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}
