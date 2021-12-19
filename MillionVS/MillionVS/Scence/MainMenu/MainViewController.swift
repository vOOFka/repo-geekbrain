//
//  MainViewController..swift
//  MillionVS
//
//  Created by Home on 30.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak private var playBtn: UIButton!
    @IBOutlet weak private var topScoresBtn: UIButton!
    //MARK: - Vars
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameSession = GameSession()
        Game.shared.gameSession = gameSession
        if let destinationVC = segue.destination as? GameTableViewController {
            destinationVC.gameDelegate = self
        }
    }

}

extension MainViewController: GameDelegate {
    func didEndGame(withResult result: GameSession) {
        self.dismiss(animated: true, completion: nil)
        guard let gameSession = Game.shared.gameSession else { return }
        gameSession.scores = result.scores
        gameSession.questionCount = result.questionCount
        gameSession.correctAnswerds = result.correctAnswerds
        Game.shared.addScore(gameSession)
        Game.shared.gameSession = nil
    }
}
