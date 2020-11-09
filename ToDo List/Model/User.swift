//
//  SFSymbolItem.swift
//  ToDo List
//
//  Created by AZM on 2020/11/06.
//

import UIKit

struct User: Decodable {
    let id: Int
    let name: String
}

extension User: Hashable {}
