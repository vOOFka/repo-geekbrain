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
    var movesPlayers: [Player:[GameboardPosition]] = [:]
    
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
        gameModeSegmentControl.isEnabled = true
        let player = Player.first
        if gameMode == .fiveInput {
            movesPlayers = [:]
            currentState = PlayerFiveInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
        } else {
            currentState = PlayerInputState(player: player,
                                            markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        }
    }
    
    private func goToNextState() {
        if gameMode != .fiveInput || movesPlayers.count == 2 {
            gameModeSegmentControl.isEnabled = false
            if movesPlayers.count == 2 {
                gameboard.clear()
                gameboardView.clear()
                currentState = ShowPlayersInputsState(player: Player.first, markViewPrototype: Player.first.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
                currentState.begin()
            }
            if let winner = self.referee.determineWinner() {
                currentState = GameEndedState(winner: winner, gameViewController: self)
                return
            }
        }
        // Simple and CPU game
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
        //Five input game
        if let fiveInputState = currentState as? PlayerFiveInputState {
            gameboard.clear()
            gameboardView.clear()
            let player = fiveInputState.player.next
            movesPlayers[fiveInputState.player] = fiveInputState.movesArray
            if movesPlayers.count == 2 {
                goToNextState()
            } else {
                currentState = PlayerFiveInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)}
        }
        
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        gameboard.clear()
        gameboardView.clear()
        goToFirstState()
        Log(.restartGame)
    }
    
    @IBAction func changeSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: gameMode = .withHuman
        case 1: gameMode = .withCPU
        case 2: gameMode = .fiveInput
        default:
            break
        }
        goToFirstState()
    }
}

