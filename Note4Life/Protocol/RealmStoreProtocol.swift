//
//  Persistable.swift
//  Note4Life
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation

protocol RealmStoreProtocol {
    func write(dataSource: RealmSourceProtocol)
    func delete(dataSource: RealmSourceProtocol)
}


