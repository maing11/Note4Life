//
//  Note.swift
//  Things+
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//


import Foundation

class Note {
    
    var identifier: String
    var content: String
    var lastEdited: Date
    var category: Category
    var trashed: Bool
    var hasDone: Bool
    
    init(
        identifier: String = UUID().uuidString,
        content: String,
        lastEdited: Date = Date(), categoryRaw: Int = 0, trashed: Bool = false, hasDone: Bool = false) {
        self.identifier = identifier
        self.content = content
        self.lastEdited = lastEdited
        self.category   = Category(rawValue: categoryRaw) ?? .Today
        self.trashed = trashed
        self.hasDone = hasDone
    }
    
}

extension Note: RealmStoreProtocol {
    
    func write(dataSource: RealmSourceProtocol) {
        self.lastEdited = Date()
        
        dataSource.store(object: self)
    }
    
    func delete(dataSource: RealmSourceProtocol) {
        dataSource.delete(object: self)
    }
}


extension Note {
    
    convenience init(realmNote: RealmNote) {
        self.init(identifier: realmNote.identifier, content: realmNote.content, lastEdited: realmNote.lastEdited, categoryRaw: realmNote.categoryRaw, trashed: realmNote.trashed, hasDone: realmNote.hasDone)
    }
    
    var realmNote: RealmNote {
        return RealmNote(note: self)
    }
    
}

