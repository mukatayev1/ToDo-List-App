//
//  MainView.swift
//  ToDo List
//
//  Created by AZM on 2020/11/07.
//

import UIKit

//MARK: - Creating a custom view

class MainView: UIView {
    
    //MARK: - Properties
    
    lazy var collectionView: UICollectionView = {
        // #step_3
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        // #step_2
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        // #step_1 setting up our collectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        setup()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Helpers
    
    func setup() {
        backgroundColor = .blue
    }
    
    func setupSubviews() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
