//
//  DataSourceable.swift
//  Things+
//
//  Created by Mai Nguyen on 3/27/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation

protocol RealmSourceProtocol {
    func store<T>(object: T)
    func delete<T>(object: T)
}

