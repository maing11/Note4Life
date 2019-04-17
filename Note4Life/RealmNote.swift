//
//  RNote.swift
//  Things+
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmNote: Object {
    
    @objc dynamic var identifier: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var lastEdited: Date = Date()
    @objc dynamic var categoryRaw: Int = 0
    @objc dynamic var trashed: Bool = false
    @objc dynamic var hasDone: Bool = false
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
    
}

extension RealmNote {
    
    convenience init(note: Note) {
        self.init()
        
        self.identifier = note.identifier
        self.content = note.content
        self.lastEdited = note.lastEdited
        self.categoryRaw = note.category.rawValue
        self.trashed = note.trashed
        self.hasDone =  note.hasDone
    }
    
    var note: Note {
        return Note(realmNote: self)
    }
    
}

