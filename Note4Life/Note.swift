//
//  Note.swift
//  Things+
//
//  Created by Larry Nguyen on 3/27/19.
//  Copyright © 2019 Larry. All rights reserved.
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

extension Note: Persistable {
    
    func write(dataSource: DataSourceable) {
        self.lastEdited = Date()
        
        dataSource.store(object: self)
    }
    
    func delete(dataSource: DataSourceable) {
        dataSource.delete(object: self)
    }
}


extension Note {
    
    convenience init(realmNote: RNote) {
        self.init(identifier: realmNote.identifier, content: realmNote.content, lastEdited: realmNote.lastEdited, categoryRaw: realmNote.categoryRaw, trashed: realmNote.trashed, hasDone: realmNote.hasDone)
    }
    
    var realmNote: RNote {
        return RNote(note: self)
    }
    
}

