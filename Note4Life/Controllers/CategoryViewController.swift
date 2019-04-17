//
//  CategoryViewController.swift
//  Things+
//
//  Created by Larry Nguyen on 3/28/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    weak var collectionView: UICollectionView!
    
    lazy var collectionViewLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: (screenWidth)/2 + 10)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return layout
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var selectedCategory: Category = .Today
    
    var categories: [Category] {
        return Category.allCategories()
    }
    
    var catCount: [Category: Int] = [:]
    
    private var bottomPullView: BottomPullView!
    private var earthTipView: EarthTipDetailView!
    
    private var bottomViewToViewConstraint: NSLayoutConstraint!
    private var originalBottomTopConstant: CGFloat = 0.0
    private var upgradeCollectionHeightConstraint: NSLayoutConstraint!
    
    private var earthDetailViewHeightConstraint: NSLayoutConstraint!
    
    let realmDataPersistence: RealmDataPersistence
    
    init(realmDataPersistence: RealmDataPersistence) {
        self.realmDataPersistence = realmDataPersistence
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
     
        self.view.backgroundColor = NoteTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Things+"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
      
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        
        setupBottomPullView()
        setupEartTipDetailView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notesDidUpdate), name: .noteDataChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryCatetoryItems()
    }
    
    fileprivate func setupCollectionView(){
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
        self.collectionView = collectionView
    }
    
    
    @objc func didTapCompose() {
        self.navigationController?.pushViewController(NoteDetailController(realmDataPersistence: self.realmDataPersistence, category: self.selectedCategory), animated: true)
    }
    
    @objc func notesDidUpdate() {
        print ("NotesViewController: Note Data Changed")
        self.collectionView.reloadData()
    }
    
    private func queryCatetoryItems(){
        for cat in self.categories {
            let count = realmDataPersistence.notesWithFilter(category: cat, filter: "").count
            catCount[cat] = count
        }
        
    }
    
    private func setupBottomPullView() {
        let firstPositionY: CGFloat = -70
        bottomPullView = BottomPullView(frame: CGRect(x: 0, y: firstPositionY, width: screenWidth, height: screenHeight))
        bottomPullView.state = .upgrade
        
        let pullGesture = UIPanGestureRecognizer(target: self, action: #selector(drawerSliding))
        bottomPullView.visibleTipView.addGestureRecognizer(pullGesture)
        
        view.addSubview(bottomPullView)
        
        bottomPullView.delegate = self
        
        var bottomAnchor = view.bottomAnchor
        bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        
        upgradeCollectionHeightConstraint = NSLayoutConstraint(item: bottomPullView.collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        upgradeCollectionHeightConstraint.priority  = .required
        
        bottomViewToViewConstraint = bottomPullView.topAnchor.constraint(equalTo: bottomAnchor, constant: firstPositionY)
        originalBottomTopConstant = bottomViewToViewConstraint.constant
        
        bottomViewToViewConstraint.isActive = true
        upgradeCollectionHeightConstraint.isActive = false
        
        let headerHeightConstraint = NSLayoutConstraint(item: bottomPullView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bottomPullView.frame.height)
        view.addConstraint(bottomViewToViewConstraint)
        view.addConstraint(headerHeightConstraint)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomPullView]-0-|", options: [], metrics: nil, views: ["bottomPullView" : bottomPullView]))
    }
    
    private func setupEartTipDetailView(){
        let view = EarthTipDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        
        let pullGesture = UIPanGestureRecognizer(target: self, action: #selector(animateDisapearEarthTip))
        view.visibleTipView.addGestureRecognizer(pullGesture)
        
        self.view.addSubview(view)
        view.bottomAnchor.constraint(equalTo:bottomPullView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: bottomPullView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: bottomPullView.trailingAnchor).isActive = true
        earthDetailViewHeightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        earthDetailViewHeightConstraint.isActive = true
        self.earthTipView = view
    }
    
    func popoutEarthTipView(tip: EarthTip){
        self.earthTipView.bodyContentLabel.text = tip.body
        self.earthTipView.visibleTipView.viewLabel.text = tip.title
        self.earthTipView.visibleTipView.imageView.image = UIImage(named: tip.imageString ?? "1")
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.curveLinear], animations: {
            self.earthDetailViewHeightConstraint.constant = 300
        }, completion: nil)
    }
    
    @objc private func animateDisapearEarthTip(_ pan: UIPanGestureRecognizer){
        UIView.animate(withDuration: 0.7) {
            self.earthDetailViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func drawerSliding(_ sender: UIPanGestureRecognizer){
        let location = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        
        if sender.state == .ended {
            if velocity.y > 0 {
                closeDrawer()
            } else {
                openDrawer()
            }
            
            bottomPullView.suspendAnimation()
            return
        } else {
            let yPosition = bottomViewToViewConstraint.constant + location.y
            if yPosition >= originalBottomTopConstant || abs(yPosition - originalBottomTopConstant) > 400 {return}
            bottomViewToViewConstraint.constant = yPosition
            sender.setTranslation(.zero, in: self.view)
        }
    }
    
    private func closeDrawer(){
        bottomViewToViewConstraint.constant = originalBottomTopConstant
        upgradeCollectionHeightConstraint.isActive = false
        bottomPullView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            
        }
    }
    
    private func openDrawer(){
        bottomViewToViewConstraint.constant = originalBottomTopConstant - 300
        upgradeCollectionHeightConstraint.isActive = true
        bottomPullView.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = categories[indexPath.row]
        let noteController = NotesViewController(realmDataPersistence: self.realmDataPersistence, category: self.selectedCategory)
        self.navigationController?.pushViewController(noteController, animated: true)
    }

}


extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as! CategoryCollectionCell
        cell.category = self.categories[indexPath.row]
        if let cat = cell.category, let count = catCount[cat] {
             cell.categoryView.countLabel.text = "\(count)"
        }
        cell.actionButtonClosure = { [unowned self] in
            self.selectedCategory = self.categories[indexPath.row]
            let noteController = NoteDetailController(realmDataPersistence: self.realmDataPersistence, category: self.selectedCategory)
            self.navigationController?.pushViewController(noteController, animated: true)
        }
        
        cell.layoutIfNeeded()
        return cell
    }

}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if categories[indexPath.row] == .All {
              return CGSize(width: collectionView.bounds.size.width - 20, height: 150)
        } else {
            return CGSize(width: (screenWidth - 30)/2, height: (screenWidth)/2 + 10)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 16)
    }

}

extension CategoryViewController: EarthTipSelectProtocol {
    func didSelectImages(count: Int, images: [UIImage]) {
        
    }
    
    func didSelectEarthTip(tip: EarthTip) {
         popoutEarthTipView(tip: tip)
    }
}
