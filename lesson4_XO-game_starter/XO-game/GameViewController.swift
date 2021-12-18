//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var gameModeSegmentControl: UISegmentedControl!
    
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    private lazy var referee = Referee(gameboard: self.gameboard)
    var gameMode: GameMode = .withHuman
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    private func goToFirstState() {
        let player = Player.first
        currentState = PlayerInputState(player: player,
                                        markViewPrototype: player.markViewPrototype,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        if let winner = self.referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            currentState = PlayerInputState(player: player,
                                            markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
            if let nextInputState = currentState as? PlayerInputState {
                if (nextInputState.player == .second) && (gameMode == .withCPU) {
                    while currentState.isCompleted == false {
                        let pos = GameboardPosition(column: Int.random(in: 0...2), row: Int.random(in: 0...2))
                        self.currentState.addMark(at: pos)
                    }
                    goToNextState()
                }
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        gameboard.clear()
        gameboardView.clear()
        goToFirstState()
        Log(.restartGame)
    }
    
    @IBAction func changeSegmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gameMode = .withHuman
        } else {
            gameMode = .withCPU
        }
    }
}

