//
//  TopScoresTableViewController.swift
//  MillionVS
//
//  Created by Home on 05.12.2021.
//

import UIKit

class TopScoresTableViewController: UITableViewController {

    private let topScores = Game.shared.topScores
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TopScoresCell.self)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topScores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TopScoresCell.self, for: indexPath)
        cell.configuration(for: indexPath.row, gameSession: topScores[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
