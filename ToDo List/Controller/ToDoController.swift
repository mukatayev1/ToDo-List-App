//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit
import RealmSwift

class ToDoController: UITableViewController {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    
    var todoItems: Results<Task>?
    
    lazy var source: TaskSource = .init(tableView: tableView) { (_, indexPath, task) -> UITableViewCell? in
        let cell = TaskCell(style: .default, reuseIdentifier: nil)
        cell.task = self.todoItems![indexPath.row]
        return cell
    }
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
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
    func loadTasks() {
        todoItems = realm.objects(Task.self)
        
        var snapshot = source.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems((todoItems?.toArray())!, toSection: .main)
//        //Force the update on the main thread to silence a warning about tableview not being in the hierarchy!
        DispatchQueue.main.async { [self] in
            source.apply(snapshot)
        }
    }
    
    func populate(with latestTask: Task) {
        var snapshot = self.source.snapshot()
        var tasksInArray = todoItems!.toArray()
        var lastTaskFromTasksArray = tasksInArray.last!
        snapshot.appendItems([lastTaskFromTasksArray])
        DispatchQueue.main.async {
            self.source.apply(snapshot)
        }
    }
    
    func save(task: Task) {
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Error saving the task \(error)")
        }
        populate(with: task)
    }
    
    //MARK: - Selectors
    @objc func barButtonAction(sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newTask = Task()
            newTask.text = textField.text!
            self.save(task: newTask)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new task"
        }
        present(alert, animated: true, completion: nil)
    }
}

extension ToDoController {
    //Left swipe
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completedAction = UIContextualAction(style: .normal, title: "Completed") { (action, view, completion) in
            completion(true)
            var snapshot = self.source.snapshot()
            
            guard let completedTask = self.source.itemIdentifier(for: indexPath) else {return}
            
            do {
                try self.realm.write {
                    completedTask.done = !completedTask.done
                    snapshot.reloadItems([completedTask])
                }
            } catch {
                print("error changing done status: \(error)")
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
            var snapshot = self.source.snapshot()
            
            guard let task = self.source.itemIdentifier(for: indexPath) else {return}
            
            do {
                try self.realm.write {
                    self.realm.delete(task)
                    snapshot.deleteItems([task])
                }
            } catch {
                print("error deleting the task: \(error)")
            }
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
