//
//  Globals.swift
//  Things+
//
//  Created by Mai Nguyen on 3/30/19.
//  Copyright © 2019 AppArt. All rights reserved.
//

import Foundation

internal func mainQueue( _ block: @escaping () -> ()){
    DispatchQueue.main.async {
        block()
    }
}

internal func mainQueueAfter(seconds: Double, _ block: @escaping () -> ()){
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        block()
    }
}

internal func globalQueue( _ block: @escaping () -> ()){
    DispatchQueue.global(qos:.default).async{
        block()
    }
}


typealias VoidClosure = () -> ()
