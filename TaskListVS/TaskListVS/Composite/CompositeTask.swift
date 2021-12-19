//
//  CompositeTask.swift
//  TaskListVS
//
//  Created by Home on 19.12.2021.
//

import Foundation

protocol TaskProtocol {
    var name: String { get }
    func open()
}

class Task: TaskProtocol {
    var name: String
    var subtasks: [TaskProtocol] = []
    
    func open() {
        print("sssss")
    }
    
    init(name: String) {
        self.name = name
    }
    
}

class SubTask: TaskProtocol {
    var name: String
    
    func open() {
        print("sssss")
    }
    
    init(name: String) {
        self.name = name
    }    
}
