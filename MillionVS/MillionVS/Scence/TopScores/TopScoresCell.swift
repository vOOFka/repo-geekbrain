//
//  TopScoresCell.swift
//  MillionVS
//
//  Created by Home on 05.12.2021.
//

import UIKit

class TopScoresCell: UITableViewCell {
    @IBOutlet weak private var numberLabel: UILabel!
    @IBOutlet weak private var correctAnswersLabel: UILabel!
    @IBOutlet weak private var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configuration(for numCell: Int, gameSession: GameSession) {
        numberLabel.text = String(numCell + 1)
        correctAnswersLabel.text = String(gameSession.correctAnswerds)
        scoreLabel.text = String(gameSession.scores)
    }
}
