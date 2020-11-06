//
//  SFSymbolItem.swift
//  ToDo List
//
//  Created by AZM on 2020/11/06.
//

import UIKit

struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}
