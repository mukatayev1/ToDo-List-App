//
//  ViewController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/05.
//

import UIKit

class ToDoController: UIViewController {
    
    //MARK: - Data for the list
    let dataItems = [
        SFSymbolItem(name: "mic"),
        SFSymbolItem(name: "mic.fill"),
        SFSymbolItem(name: "message"),
        SFSymbolItem(name: "message.fill"),
        SFSymbolItem(name: "sun.min"),
        SFSymbolItem(name: "sun.min.fill"),
        SFSymbolItem(name: "sunset"),
        SFSymbolItem(name: "sunset.fill"),
        SFSymbolItem(name: "pencil"),
        SFSymbolItem(name: "pencil.circle"),
        SFSymbolItem(name: "highlighter"),
        SFSymbolItem(name: "pencil.and.outline"),
        SFSymbolItem(name: "personalhotspot"),
        SFSymbolItem(name: "network"),
        SFSymbolItem(name: "icloud"),
        SFSymbolItem(name: "icloud.fill"),
        SFSymbolItem(name: "car"),
        SFSymbolItem(name: "car.fill"),
        SFSymbolItem(name: "bus"),
        SFSymbolItem(name: "bus.fill"),
        SFSymbolItem(name: "flame"),
        SFSymbolItem(name: "flame.fill"),
        SFSymbolItem(name: "bolt"),
        SFSymbolItem(name: "bolt.fill")
    ]
    
    //MARK: - Properties

    //Define section for
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    
    // Create cell registration that defines how data should be shown in a cell
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> { (cell, indexPath, item) in
        
        // Define how data should be shown using content configuration
        var content = cell.defaultContentConfiguration()
        content.image = item.image
        content.text = item.name
        
        // Assign content configuration to cell
        cell.contentConfiguration = content
    }
    
    //create diffable data source
    var dataSource: UICollectionViewDiffableDataSource<Section, SFSymbolItem>!
    
    //diffable data source snapshot for later use, to tell our view controller what data to show.
    var snapshot: NSDiffableDataSourceSnapshot<Section, SFSymbolItem>!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupUI()
        collectionView.delegate = self
    }
    
    //MARK: - Helpers
    
    func setupUI() {
        setupCollectionView()
    }
    
    //MARK: - UICollectionView
    
    func setupCollectionView() {
        //create list layout
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        //create colection view with list layout
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        setupDataSource()
        
        //Snapshot
        // Create a snapshot that define the current state of data source's data
        snapshot = NSDiffableDataSourceSnapshot<Section, SFSymbolItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)

        // Display data in the collection view by applying the snapshot to data source
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, SFSymbolItem> (collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SFSymbolItem) -> UICollectionViewCell? in
            
            // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath,  item: identifier)
            // Configure cell appearance
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
    }

}

extension ToDoController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Retrieve the item identifier using index path.
        // The item identifier we get will be the selected data item
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        // Show selected SFSymbol's name
        let alert = UIAlertController(title: selectedItem.name, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            // Deselect the selected cell
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion:nil)
    }
    
}
