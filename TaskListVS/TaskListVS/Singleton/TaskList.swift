//
//  TaskList.swift
//  TaskListVS
//
//  Created by Home on 19.12.2021.
//

import Foundation

class TaskList {
    private init() {}
    
    static let shared = TaskList()
    var taskList: [TaskProtocol] = MockResponseToGetTasks()
}
