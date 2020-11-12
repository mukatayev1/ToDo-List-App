//
//  Task.swift
//  ToDo List
//
//  Created by AZM on 2020/11/09.
//

import Foundation

class Task: NSObject {
    var text: String
    var done = false
    
    init(text: String) {
        self.text = text
    }
    
}

enum Section {
    case todo
    case completed
}
