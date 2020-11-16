//
//  NewTaskController.swift
//  ToDo List
//
//  Created by AZM on 2020/11/09.
//

import UIKit

protocol NewTaskControllerDelegate {
    func didAddTask(_ task: Task)
}

class NewTaskController: UIViewController {
    
    //MARK: - Properties
    var delegate: NewTaskControllerDelegate?
    var newTask: Task?
    var viewModel = NewTaskViewModel()
    var cardView: UIView = {
        let myView = UIView()
        myView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        myView.layer.cornerRadius = 15
        return myView
    }()
    
    private let taskTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Task to do"
        tf.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(K.checkmarkImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.5333333333, blue: 0.831372549, alpha: 1)
        button.isEnabled = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "New Task", prefersLargeTitles: false)
        taskTextField.becomeFirstResponder()
        taskTextField.delegate = self
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        hideKeyboardWhenTappedAround()
        //subviews
        subviewCardView()
        subviewTextField()
        subviewDoneButton()
    }
    
    //MARK: - Helpers
    func checkFormStatus() {
        if viewModel.formIsValid {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
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
        newTask = Task(text: taskTextField.text ?? "")
        delegate?.didAddTask(newTask!)
    }
    
    @objc func textDidChange() {
        viewModel.text = taskTextField.text
        checkFormStatus()
    }
}

extension NewTaskController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        doneButtonTapped()
        return true
    }
}
