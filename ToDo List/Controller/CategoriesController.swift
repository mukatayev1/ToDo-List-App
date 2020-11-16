//
//  CategoriesController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/16.
//

import UIKit
import RealmSwift

class CategoriesController: UIViewController {
    
    //MARK: - Properties
    
    let realm = try! Realm()
    
    var categories: Results<Category>!
    
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
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        setupNavigationBar(title: "ToDo List", prefersLargeTitles: true)
        view.backgroundColor = .systemGroupedBackground
        loadCategories()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.reuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //subviewing
        subviewElements()
        subviewAddButton()
    }
    
    //MARK: - Helpers
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
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
    @objc func addButtonTapped(sender: UIButton) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategory(category: newCategory)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            alertTextField.layer.cornerRadius = 10
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


extension CategoriesController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Categories"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
