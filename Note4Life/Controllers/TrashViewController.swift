//
//  TrashViewController.swift
//  Things+
//
//  Created by Larry Nguyen on 3/28/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import UIKit

class TrashViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        let image = UIImage(named: "icons8-xbox_x_filled")
        let tintImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintImage, for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named:"icons8-delete_filled")
        let tintImage = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.image = tintImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = UIColor.white
        label.numberOfLines = 2
        label.text = "No Trash, It is good for the earth"
        label.backgroundColor = .clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        label.sizeToFit()
        return label
    }()
    
    let deleteReminderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = UIColor.white
        label.numberOfLines = 2
        label.text = "All notes in the trash will be deleted after 30 days"
        label.backgroundColor = .clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
       
        label.sizeToFit()
        return label
    }()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var notes: [Note] {
        return self.realmDataPersistence.trashedNotesWithFilter(isTrashed: true)
    }

    let realmDataPersistence: RealmDataPersistence
    
    init(realmDataPersistence: RealmDataPersistence) {
        self.realmDataPersistence = realmDataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        self.view.height = screenHeight - 100
        self.view.backgroundColor = NoteTheme.backgroundColor
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let originalImage = UIImage(named: "icons8-delete")
        let tintImage = originalImage?.withRenderingMode(.alwaysTemplate)
        self.navigationItem.titleView = UIImageView(image: tintImage)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableFooterView = UIView() // Remove the empty separator lines
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = CGFloat(50)
        
        self.tableView.register(ThingsNoteTableCell.self, forCellReuseIdentifier: ThingsNoteTableCell.identifier)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.emptyImageView)
        self.view.addSubview(self.emptyLabel)
        self.view.addSubview(self.deleteReminderLabel)
       
        
        
        self.deleteReminderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        self.deleteReminderLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.deleteReminderLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
      
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo:  self.deleteReminderLabel.bottomAnchor, constant: 10).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        

        self.closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.emptyImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.emptyImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        self.emptyImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.emptyImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.emptyImageView.isHidden = !notes.isEmpty
        
        
        self.emptyLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.emptyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.emptyLabel.topAnchor.constraint(equalTo: self.emptyImageView.bottomAnchor).isActive = true
        
        self.emptyLabel.isHidden = !notes.isEmpty
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(notesDidUpdate), name: .noteDataChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for note in self.notes {
            if daysBetween(date1: note.lastEdited, date2: Date()) > 30 {
                note.delete(dataSource: self.realmDataPersistence)
            }
            
            tableView.reloadData()
        }
       
    }
    
    @objc func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func notesDidUpdate() {
        print ("NotesViewController: Note Data Changed")
        self.tableView.reloadData()
    }
    
    @objc func clearTrash(_ sender: UITapGestureRecognizer){
        if notes.isEmpty {
            self.presentAlert(withTitle: "Empty Bin", message: "There is nothing in the bin now")
        }
        for note in self.notes {
            note.delete(dataSource: self.realmDataPersistence)
        }
    }
    
}

extension TrashViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
        let recoverString = NSLocalizedString("Recycle", comment: "Recycle action")
        let recoverAction = UITableViewRowAction(style: .normal, title: recoverString) { (action, indexPath) in
            let select = self.notes[indexPath.row]
            select.trashed = false
            select.write(dataSource: self.realmDataPersistence)
            self.tableView.reloadData()
        }
        
        recoverAction.backgroundColor = UIColor.green
        return [recoverAction]
    }
}


extension TrashViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThingsNoteTableCell.identifier, for: indexPath) as! ThingsNoteTableCell
        cell.note = self.notes[indexPath.row]
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
}

extension TrashViewController {
    func daysBetween(date1: Date, date2: Date) -> Int {
        
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: date1)
        let date2 = calendar.startOfDay(for: date2)
        
        let flags = Set<Calendar.Component>([.day, .month, .year, .hour])
        let components = calendar.dateComponents(flags, from: date1, to: date2)
    
        return components.day ?? 0
    }
}

