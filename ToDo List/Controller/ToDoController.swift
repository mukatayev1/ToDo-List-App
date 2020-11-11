//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit

var todoItems = [Task]()

class ToDoController: UITableViewController {
    
    //MARK: - Properties
    
    lazy var source: TaskSource = .init(tableView: tableView) { (_, indexPath, task) -> UITableViewCell? in
        
        let cell = TaskCell(style: .default, reuseIdentifier: nil)
        
        cell.task = todoItems[indexPath.row]
        return cell
    }
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addTaskButton: UIBarButtonItem = {
            let barButton = UIBarButtonItem(image: K.addImage, style: .plain, target: self, action: #selector(barButtonAction(sender:)))
            barButton.tintColor = .black
            return barButton
        }()
        
        toolbarItems = [spacer, addTaskButton]
        navigationController?.isToolbarHidden = false
        addTaskButton.action = #selector(barButtonAction)
        setupSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "My To-Do", prefersLargeTitles: true)
    }
    
    //MARK: - Helpers
    
    func setupSource() {
        
        var snapshot = source.snapshot()
        snapshot.appendSections([.todo, .completed])
        snapshot.appendItems(todoItems, toSection: .todo)
        source.apply(snapshot)
    }
    
    func populate(with task: Task, section: Section) {
//        print("Initial State: \(todoItems)")
        todoItems.append(task)
//        print("After adding State: \(todoItems)")
//        print("The last item in array form: \([todoItems.last!])")
        
        var snapshot = self.source.snapshot()
        snapshot.appendItems([todoItems.last!], toSection: section)
        self.source.apply(snapshot)
    }
    
    //MARK: - TableView
    
    //swiping actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            completion(true)
            
            guard let task = self.source.itemIdentifier(for: indexPath) else {return}
            
            var snapshot = self.source.snapshot()
            snapshot.deleteItems([task])
            self.source.apply(snapshot)

            todoItems.remove(at: indexPath.row)
            
        }
        deleteAction.image = UIImage(systemName: "trash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        
        return .init(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completedAction = UIContextualAction(style: .normal, title: "Completed") { (action, view, completion) in
            completion(true)
            
            guard let completedTask = self.source.itemIdentifier(for: indexPath) else {return}
            var snapshot = self.source.snapshot()
            
            snapshot.appendItems([completedTask], toSection: .completed)
            self.source.apply(snapshot)
        }
        completedAction.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        completedAction.backgroundColor = .systemGreen
        
        return.init(actions: [completedAction])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = section == 0 ? "ToDo" : "Completed"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Selectors
    
    @objc func barButtonAction(sender: UIBarButtonItem) {
        let vc = NewTaskController()
        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
//        var snapshot = self.source.snapshot()
//        snapshot.appendItems(completedItems, toSection: .completed)
//        self.source.apply(snapshot)
    
    }

}

extension ToDoController: NewTaskControllerDelegate {
    func didAddTask(_ task: Task) {
        populate(with: task, section: .todo)
    }
    
    
}
