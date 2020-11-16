//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit
import RealmSwift

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
        setupSource()
        let addTaskButton: UIBarButtonItem = {
            let barButton = UIBarButtonItem(image: K.addImage, style: .plain, target: self, action: #selector(barButtonAction(sender:)))
            barButton.tintColor = #colorLiteral(red: 0.5647058824, green: 0.5333333333, blue: 0.831372549, alpha: 1)
            return barButton
        }()
        toolbarItems = [spacer, addTaskButton]
        navigationController?.isToolbarHidden = false
        addTaskButton.action = #selector(barButtonAction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "My To-Do", prefersLargeTitles: true)
    }
 
    //MARK: - Helpers
    func setupSource() {
        var snapshot = source.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(todoItems, toSection: .main)
        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async { [self] in
            source.apply(snapshot)
        }
    }
    
    func populate(task: Task, section: Section) {
        var snapshot = self.source.snapshot()
        todoItems.append(task)
        snapshot.appendItems([todoItems.last!], toSection: section)
        DispatchQueue.main.async {
            self.source.apply(snapshot)
        }
    }
    
    //MARK: - Selectors
    @objc func barButtonAction(sender: UIBarButtonItem) {
        let vc = NewTaskController()
        navigationController?.pushViewController(vc, animated: true)
        vc.delegate = self
    }
}

extension ToDoController: NewTaskControllerDelegate {
    func didAddTask(_ task: Task) {
        populate(task: task, section: .main )
    }
}

extension ToDoController {
    //Left swipe
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completedAction = UIContextualAction(style: .normal, title: "Completed") { (action, view, completion) in
            completion(true)
            
            let completedTask = self.source.itemIdentifier(for: indexPath)!
            var snapshot = self.source.snapshot()
            
            if completedTask.done == false {
                completedTask.done = true
                snapshot.reloadItems([completedTask])
            } else {
                completedTask.done = false
                snapshot.reloadItems([completedTask])
            }
            self.source.apply(snapshot)
        }
        
        completedAction.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        completedAction.backgroundColor = .systemGreen
        return.init(actions: [completedAction])
    }
    
    //Right swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            completion(true)
            
            guard let task = self.source.itemIdentifier(for: indexPath) else {return}
            var snapshot = self.source.snapshot()
            snapshot.deleteItems([task])
            todoItems.remove(at: indexPath.row)
            self.source.apply(snapshot)
        }
        deleteAction.image = UIImage(systemName: "trash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        return .init(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "ToDo"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
