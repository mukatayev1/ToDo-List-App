//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit

class ToDoController: UITableViewController {
    
    //MARK: - Properties
    
    lazy var source: TaskSource = .init(tableView: tableView) { (_, indexPath, task) -> UITableViewCell? in
        
        let cell = TaskCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = task.text
        return cell
    }
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private let addTaskButton: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(handleAddButton))
        buttonItem.tintColor = .black
        return buttonItem
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItems = [spacer, addTaskButton]
        navigationController?.isToolbarHidden = false
        setupSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "My To-Do", prefersLargeTitles: true)
    }
    
    //MARK: - Helpers
    
    func setupSource() {
        
        var snapshot = source.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.init(text: "Get apples"),
                              .init(text: "Renew the subscription for netflix"),
                               .init(text: "Update mac")])
        source.apply(snapshot)
    }
    
    //swiping actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            completion(true)
            
            guard let contact = self.source.itemIdentifier(for: indexPath) else {return}
            
            var snapshot = self.source.snapshot()
            snapshot.deleteItems([contact])
            self.source.apply(snapshot)
            
        }
        return .init(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Tasks"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Subviews
    
    //MARK: - Selectors
    
    @objc func handleAddButton() {
        print("add button")
    }

}
