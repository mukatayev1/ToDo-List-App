//
//  Constants.swift
//  ToDo List
//
//  Created by AZM on 2020/11/09.
//

import UIKit

struct K {
    
    static let reuseIdentifier = "CategoryCell"
    static let reuseIdentifier2 = "TaskCell"
    
    static let addImage = UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
    
    static let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
    
    static let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
    
    static let checkmarkStarImage = UIImage(systemName: "checkmark.seal.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium))?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)

}
