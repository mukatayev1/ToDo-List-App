//
//  Task.swift
//  ToDo List
//
//  Created by AZM on 2020/11/09.
//

import Foundation

struct Task: Hashable {
    var text: String
    var done = false
}

enum Section {
    case todo
    case completed
}
