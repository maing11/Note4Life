//
//  NotesViewController.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//


import UIKit
import RealmSwift

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let statusbarHeight = UIApplication.shared.statusBarFrame.height

class NotesViewController: UIViewController {
    
    var category: Category = .Work
    var selectedNote: Note?

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.isTranslucent = false
        searchBar.placeholder = "Search"
        searchBar.tintColor = UIColor.lightGray
        searchBar.showsCancelButton = true
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.barTintColor = UIColor.clear
        searchBar.isUserInteractionEnabled = true
        searchBar.showsCancelButton = false
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let trashButton: UIButton = {
        let trash = UIButton()
        trash.translatesAutoresizingMaskIntoConstraints = false
        let origImage = UIImage(named: "icons8-delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        trash.setImage(tintedImage, for: .normal)
        trash.tintColor = .white
        trash.addTarget(self, action: #selector(trashPressed), for: .touchUpInside)
        return trash
    }()
    
    let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        let image = UIImage(named: "paw2")
        imageView.contentMode = .scaleAspectFit
        let tintImage = image?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        return imageView
    }()
    
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var notes: [Note] {
        get {
            return self.realmDataPersistence.notesWithFilter(category: category, filter: searchBar.text ?? "")
        }

    }
 
    let realmDataPersistence: RealmDataPersistence
    
    init(realmDataPersistence: RealmDataPersistence, category: Category) {
        self.realmDataPersistence = realmDataPersistence
        self.category = category
        
        super.init(nibName: nil, bundle: nil)
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
        self.navigationItem.title = category.categoryName()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        
        
        view.isUserInteractionEnabled = true
        
        searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView() // Remove the empty separator lines
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = CGFloat(50)
        
        self.tableView.register(ThingsNoteTableCell.self, forCellReuseIdentifier: ThingsNoteTableCell.identifier)
        
        
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.trashButton)
        self.view.addSubview(self.centerImageView)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.trashButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.trashButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.trashButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.trashButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.trashButton.leadingAnchor).isActive = true
        self.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.centerImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.centerImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.centerImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.centerImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(notesDidUpdate), name: .noteDataChanged, object: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    

    

    @objc func didTapCompose() {
        self.navigationController?.pushViewController(NoteDetailController(realmDataPersistence: self.realmDataPersistence, category: category), animated: true)
    }
    
    @objc func notesDidUpdate() {
        print ("NotesViewController: Note Data Changed")
        self.tableView.reloadData()
    }
    
    @objc func trashPressed(_ sender: UIButton){
        let viewController = BinViewController(realmDataPersistence:self.realmDataPersistence)
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func showAlert() {
        let alertController = MyAlertController(title: "Pick Category", message: "😀🌵🐚🍋", preferredStyle: .alert)
        
        for category in Category.allCategories() {
            let origImage = UIImage(named:category.categoryImageName())
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            
            let categoryAction = UIAlertAction(title: category.categoryName(), style: .default, image: tintedImage){ _ in
                self.selectedNote?.category = category
                self.selectedNote?.write(dataSource: self.realmDataPersistence)
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
    
    @objc func dismissKeyboard(){
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    

    
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NoteDetailController(realmDataPersistence: self.realmDataPersistence, category: category)
        controller.note = self.notes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTitle = "Delete"
        let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle) { (action, indexPath) in
            let select = self.notes[indexPath.row]
            select.trashed = true
            self.notes[indexPath.row].trashed = true
            select.write(dataSource: self.realmDataPersistence)
            mainQueue {
                self.tableView.reloadData()
            }
                                                    
        }
       
        let changeCategory = "Change"
        let changeCategoryAction = UITableViewRowAction(style: .normal, title: changeCategory) { (action, indexPath) in
            let select = self.notes[indexPath.row]
            self.selectedNote = select
            self.showAlert()
        }
        changeCategoryAction.backgroundColor = UIColor.black
        
        return [changeCategoryAction, deleteAction]
    }
    
  
}


extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThingsNoteTableCell.identifier, for: indexPath) as! ThingsNoteTableCell
        cell.note = self.notes[indexPath.row]
        cell.checkButtonClosure = { [unowned self] in
            let select = self.notes[indexPath.row]
            select.hasDone = !select.hasDone
            select.write(dataSource: self.realmDataPersistence)
            mainQueue {
                self.tableView.reloadData()
            }
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    
    
}

extension NotesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    
}


