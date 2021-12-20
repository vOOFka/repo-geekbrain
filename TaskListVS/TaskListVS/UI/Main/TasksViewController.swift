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
    
    var currentTask: TaskProtocol = TaskList.shared.rootTask
    var rootTasksArray: [TaskProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(TaskCell.self)
        currentTask.subtasks = MockResponseToGetTasks()
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        showAdd()
    }
    @IBAction func tapBackButton(_ sender: Any) {
        if !rootTasksArray.isEmpty {
            currentTask = rootTasksArray.removeLast()
            tableView.reloadData()
            showBackButton()
        }
    }
}

extension TasksViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectTask = currentTask.subtasks[indexPath.row]
        rootTasksArray.append(currentTask)
        currentTask = selectTask
        showBackButton()
        tableView.reloadData()
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentTask.subtasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TaskCell.self, for: indexPath)
        cell.configuration(task: currentTask.subtasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

extension TasksViewController {
    fileprivate func showBackButton() {
        let hasRootTasks = !rootTasksArray.isEmpty ? true : false
        navigationItem.leftBarButtonItems?.first?.isEnabled = hasRootTasks
    }
    
    fileprivate func showAdd() {
        let alertController = UIAlertController(title: "Add New task", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter task name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            guard let text = alertController.textFields?.first?.text else { return }
            let newTask = Task(name: text)            
            self.currentTask.subtasks.append(newTask)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
