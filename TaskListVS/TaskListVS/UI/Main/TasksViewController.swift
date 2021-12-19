//
//  TasksViewController.swift
//  TaskListVS
//
//  Created by Home on 19.12.2021.
//

import UIKit

class TasksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var currentTask: TaskProtocol?
    var tasksArray = TaskList.shared.taskList {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(TaskCell.self)
    }
    @IBAction func tapAddButton(_ sender: Any) {
        showAdd()
    }
}

extension TasksViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectTask = tasksArray[indexPath.row]
        let childVC = ChildVC()
        childVC.currentTask = selectTask
        //childVC.tasksArray = selectTask.subtasks
        childVC.addButton = addButton
        
        TaskList.shared.taskList = tasksArray
        
        childVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(childVC, animated: true)
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TaskCell.self, for: indexPath)
        cell.configuration(task: tasksArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

extension TasksViewController {
    fileprivate func showAdd() {
        let alertController = UIAlertController(title: "Add New task", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter task name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            guard let text = alertController.textFields?.first?.text else { return }
            let newTask = Task(name: text)
            self.tasksArray.append(newTask)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
