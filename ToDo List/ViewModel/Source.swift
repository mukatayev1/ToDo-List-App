//
//  Source.swift
//  ToDo List
//
//  Created by AZM on 2020/11/10.
//

import UIKit

class TaskSource: UITableViewDiffableDataSource<Section, Task> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
