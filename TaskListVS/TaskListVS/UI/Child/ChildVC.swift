//
//  ChildVC.swift
//  TaskListVS
//
//  Created by Home on 19.12.2021.
//

import UIKit

class ChildVC: TasksViewController {
    let childTableView = UITableView()
    
    var currentSubTask: TaskProtocol?
    override var tasksArray: [TaskProtocol] {
        didSet {
            childTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        childTableView.dataSource = self
        childTableView.delegate = self
        tasksArray = currentTask?.subtasks ?? []
    }
    
    func setup() {
        tableView?.removeFromSuperview()
        view.addSubview(childTableView)
        childTableView.register(TaskCell.self)
        childTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            childTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            childTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            childTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        childTableView.reloadData()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButtonInChild(_:)))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    @objc func tapAddButtonInChild(_ sender: Any) {
        showAdd()
    }
    
}

extension ChildVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TaskCell.self, for: indexPath)
        cell.configuration(task: tasksArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

extension ChildVC {
    fileprivate func showAdd() {
        let alertController = UIAlertController(title: "Add New task", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter task name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            guard let text = alertController.textFields?.first?.text else { return }
            let newTask = Task(name: text)
            self.tasksArray.append(newTask)
            self.childTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
