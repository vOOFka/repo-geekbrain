//
//  PlayerInputStateWithCommands.swift
//  XO-game
//
//  Created by Home on 19.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public class PlayerInputStateWithCommands: GameState {
    
    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    let markViewPrototype: MarkView
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.text = "2nd player"
        }
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        guard let gb = gameboard, let gbv = gameboardView else { return }
        Move(player: player, position: position, gameboard: gb, gameboardView: gbv)
        executeMovesIfNeeded()
        self.isCompleted = true
    }
}
