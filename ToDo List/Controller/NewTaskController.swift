//
//  NewTaskController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/09.
//

import UIKit

class NewTaskController: UIViewController {
    
    //MARK: - Properties
    
    var cardView: UIView = {
        let myView = UIView()
        myView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        myView.layer.cornerRadius = 15
        return myView
    }()
    
    var taskTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write your task"
        tf.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        return tf
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1285493338, green: 0.1285493338, blue: 0.1285493338, alpha: 1)
        
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: -3, height: -3)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "New Task", prefersLargeTitles: false)

        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        //subviews
        subviewCardView()
        subviewTextField()
        subviewDoneButton()
    }
    
    //MARK: - Helpers
    
    //MARK: - Subviews
    
    func subviewCardView() {
        view.addSubview(cardView)
    
        cardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
    func subviewTextField() {
        view.addSubview(taskTextField)
    
        taskTextField.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, right: cardView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 15)
    }
    
    func subviewDoneButton() {
        view.addSubview(doneButton)
        doneButton.setDimensions(height: 50, width: 50)
        doneButton.layer.cornerRadius = 50 / 2
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 20, paddingRight: 20)
    }
    
    //MARK: - Selectors
    
    @objc func doneButtonTapped() {
        print("Save the task")
        
        navigationController?.popToRootViewController(animated: true)
    }
}
