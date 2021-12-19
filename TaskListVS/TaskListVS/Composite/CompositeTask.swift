//
//  CompositeTask.swift
//  TaskListVS
//
//  Created by Home on 19.12.2021.
//

import Foundation

protocol TaskProtocol {
    var name: String { get set }
    var subtasks: [TaskProtocol] { get set }
    func open()
    func add(_ task: TaskProtocol)
}

class Task: TaskProtocol {
    var name: String
    var subtasks: [TaskProtocol] = []
    var isRootTask = false
    
    func open() {
        print("some task")
    }
    
    func add(_ task: TaskProtocol) {
        subtasks.append(task)
    }
    
    init(name: String) {
        self.name = name
    }    
}



func MockResponseToGetTasks() -> [TaskProtocol] {
    let mockTasks = ["First task", "Second task", "Third task", "Fourth task", "Fifth task", "Sixth task"]
    let mockSubTasks = ["SubTask One", "SubTask Two"]
    var tasks = [TaskProtocol]()
    mockTasks.forEach({
        let task = Task(name: $0)
        task.isRootTask = true
        tasks.append(task)
    })
    var subTasks = [TaskProtocol]()
    mockSubTasks.forEach({
        let subTask = Task(name: $0)
        subTasks.append(subTask)
    })
    tasks[0].subtasks = subTasks 
    return tasks
}
