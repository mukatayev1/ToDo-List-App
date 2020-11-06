//
//  Extensions.swift
//  ToDo List
//
//  Created by AZM on 2020/11/06.
//

import UIKit

extension UIViewController {
    
    func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        let navBar = navigationController?.navigationBar
        
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0.1285493338, green: 0.1285493338, blue: 0.1285493338, alpha: 1)
        
        navBar?.standardAppearance = appearance
        navBar?.compactAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        
        navBar?.prefersLargeTitles = true
        navigationItem.title = "My To-Do"
        navBar?.tintColor = .white
        navBar?.isTranslucent = true
        
        navBar?.overrideUserInterfaceStyle = .dark
    }
    
}
