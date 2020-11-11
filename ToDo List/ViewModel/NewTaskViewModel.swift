//
//  NewTaskViewModel.swift
//  ToDo List
//
//  Created by AZM on 2020/11/11.
//

import Foundation

struct NewTaskViewModel {
    
    var text: String?
    
    var formIsValid: Bool {
        return text?.isEmpty == false
    }
    
}
