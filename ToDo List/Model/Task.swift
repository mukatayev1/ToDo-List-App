//
//  Item.swift
//  ToDo List
//
//  Created by AZM on 2020/11/16.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var done: Bool = false
}

enum Section {
    case main
}
