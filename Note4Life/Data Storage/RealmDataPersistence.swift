//
//  RealmDataPersistence.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataPersistence: DataSourceable {
    
    var notes: [Note] {
        let objects = realm.objects(RNote.self).sorted(byKeyPath: "lastEdited", ascending: false)
        
        return objects.map {
            return $0.note
        }
    }
    
    func notesWithFilter(category: Category,filter: String) -> [Note] {
        let objects = realm.objects(RNote.self).sorted(byKeyPath: "lastEdited", ascending: false)
        var myObjects = objects
        if filter != "" {
            myObjects = objects.filter("content CONTAINS[cd] %@", filter).sorted(byKeyPath: "lastEdited", ascending: false)
        }
        if category == .All {
            return myObjects.map {
                return $0.note
                }.filter{
                    $0.trashed == false
            }
        }
        
        return myObjects.map {
            return $0.note
            }.filter{
                $0.category == category && $0.trashed == false
        }
    }
    
    func trashedNotesWithFilter(isTrashed: Bool) -> [Note] {
        let objects = realm.objects(RNote.self).sorted(byKeyPath: "lastEdited", ascending: false)
        return objects.map {
            return $0.note
            }.filter{
                $0.trashed == isTrashed
        }
    }
    
    var realm: Realm
    
    init() {
        // Load our data
        self.realm = try! Realm()
    }
    
    func store<T>(object: T) {
        guard let note = object as? Note else {
            return
        }
        
        // Save our note
        try? self.realm.write {
            self.realm.add(note.realmNote, update: true)
        }
        
        NotificationCenter.default.post(name: .noteDataChanged, object: nil)
    }
    
    func delete<T>(object: T) {
        guard let note = object as? Note else {
            return
        }
        
        // Delete our note
        if let realmNote = self.realm.object(ofType: RNote.self, forPrimaryKey: note.identifier) {
            self.realm.beginWrite()
            self.realm.delete(realmNote)
            try? self.realm.commitWrite()
        }
        
        NotificationCenter.default.post(name: .noteDataChanged, object: nil)
    }
    
}

extension Notification.Name {
    
    static let noteDataChanged = Notification.Name(rawValue: "noteDataChanged")
    static let earthJsonLoaded = Notification.Name(rawValue: "earthJsonLoaded")
    
}

