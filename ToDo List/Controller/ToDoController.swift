//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit

struct Task: Hashable {
    let text: String
}

class ToDoController: UIViewController {
    
    //MARK: - Properties
    
    let mainView = MainView()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Task>?
    
    var dataTasks = [Task(text: "get the milk"),
                     Task(text: "transfer the money for school"),
                     Task(text: "Arrange my closet")
    ]
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1285493338, green: 0.1285493338, blue: 0.1285493338, alpha: 1)
        
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: -3, height: -3)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        populate(with: dataTasks)
//        configureNavigationController()
        
        //Subviewing
        subviewAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "My To-Do", prefersLargeTitles: true)
    }
    
    //MARK: - Helpers
    
    func setupCollectionView() {
        //create a registration method. To use cellRegistration we use collectionView List cell and object "Task"
        //We can use UICollectionViewListCell or CustomCell tat will conform to certain protocoles in order to use it with content
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Task> { cell, indexpath, task in
            
            //default contentConfigureation includes image and text
            var content = cell.defaultContentConfiguration()
            content.text = task.text
            
            //pass the content to cell content
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Task>(collectionView: mainView.collectionView) { (collectionView, indexPath, task) in
            
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: task)
        }
    }
    
    //method to populate our list with tasks
    func populate(with tasks: [Task]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task> ()
        snapshot.appendSections([.main])
        snapshot.appendItems(tasks)
        dataSource?.apply(snapshot)
    }
    
    //MARK: - Subviews
    
    func subviewAddButton() {
        view.addSubview(addButton)
        addButton.setDimensions(height: 50, width: 50)
        addButton.layer.cornerRadius = 50 / 2
        addButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 15, paddingRight: 25)
    }
    
    //MARK: - Selectors
    
    @objc func addButtonTapped() {
        print("add task")
        let vc = NewTaskController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - Extensions
//A single section extension in order to use the section in diffable data source that requires Section.
extension ToDoController {
    enum Section {
        case main
    }
}
