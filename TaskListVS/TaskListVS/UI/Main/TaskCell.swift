//
//  TaskCell.swift
//  TaskListVS
//
//  Created by Home on 19.12.2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    let cellReuseIdentifier = "TaskCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtasksLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configuration (task: TaskProtocol) {
        self.nameLabel.text = "\(task.name)"
        self.subtasksLabel.text = "Count of subtasks: \(task.subtasks.count)"
    }   
    
}
