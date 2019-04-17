//
//  CategoryViewController.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/28/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    weak var collectionView: UICollectionView!
    
    lazy var collectionViewLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (screenWidth - 30)/3, height: (screenWidth)/2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return layout
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var selectedCategory: Category = .Work
    
    var categories: [Category] {
        return Category.allCategories()
    }
    
    var catCount: [Category: Int] = [:]
    
  
    
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
        self.navigationItem.title = "Note4Life"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionView.backgroundColor = .clear
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
      
        collectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: HomeCollectionCell.identifier)
        
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

}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = categories[indexPath.row]
        let noteController = NotesViewController(realmDataPersistence: self.realmDataPersistence, category: self.selectedCategory)
        self.navigationController?.pushViewController(noteController, animated: true)
    }

}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCell.identifier, for: indexPath) as! HomeCollectionCell
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if categories[indexPath.row] == .All {
              return CGSize(width: collectionView.bounds.size.width - 20, height: 200)
        } else {
            return CGSize(width: (screenWidth - 30)/3, height: (screenWidth)/2 - 30)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 16)
    }

}

extension HomeViewController: EarthTipSelectProtocol {
    func didSelectImages(count: Int, images: [UIImage]) {
        
    }
    
    func didSelectEarthTip(tip: Tip) {
        
    }
}
