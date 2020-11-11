//
//  TaskCell.swift
//  ToDo List
//
//  Created by AZM on 2020/11/10.
//

import UIKit

class TaskCell: UITableViewCell {
    
    //MARK: - Properties
    
    var task: Task? {
        didSet { configure() }
    }
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return tv
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        subviewElements()
//        configure()
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func subviewElements() {
//        addSubview(checkMark)
//        checkMark.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingLeft: 0)
//        checkMark.setDimensions(height: 30, width: 30)
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10)
    }
    
    func configure() {
        guard let task = task else { return }
        textView.text = task.text
        if task.done == false {
            textView.textColor = UIColor.black
        }

    }
}
