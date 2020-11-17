//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit
import RealmSwift

class ToDoController: UIViewController {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    
    var todoItems: Results<Task>?
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .systemGroupedBackground
        return tv
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.plusImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.5333333333, blue: 0.831372549, alpha: 1)
        button.addTarget(self, action: #selector(barButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var source: TaskSource = .init(tableView: tableView) { (_, indexPath, task) -> UITableViewCell? in
        let cell = TaskCell(style: .default, reuseIdentifier: nil)
        cell.task = self.todoItems![indexPath.row]
        return cell
    }
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadTasks()
        self.tableView.delegate = self
        self.tableView.dataSource = source
    }
 
    //MARK: - Helpers
    
    func setupView(){
        setupNavigationBar(title: "My To-Do", prefersLargeTitles: true)
        view.backgroundColor = .systemGroupedBackground
        //Subviewing
        subviewElements()
        subviewAddButton()
    }
    
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
    
    //MARK: - Subviews
    func subviewElements() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 80)
    }
    
    func subviewAddButton() {
        view.addSubview(addButton)
        addButton.setDimensions(height: 50, width: 50)
        addButton.layer.cornerRadius = 50 / 2
        addButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, paddingRight: 20)
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

extension ToDoController: UITableViewDelegate {
    //Left swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "ToDo"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
