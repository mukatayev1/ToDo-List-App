//
//  CategoryCell.swift
//  ToDo List
//
//  Created by AZM on 2020/11/16.
//

import UIKit

class CategoryCell: UITableViewCell {
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
