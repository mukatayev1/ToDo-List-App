//
//  Category.swift
//  ToDo List
//
//  Created by AZM on 2020/11/16.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
