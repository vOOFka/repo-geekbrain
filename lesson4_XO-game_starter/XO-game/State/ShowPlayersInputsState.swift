//
//  ShowPlayersInputsState.swift
//  XO-game
//
//  Created by Home on 18.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class ShowPlayersInputsState: GameState {
    
    public private(set) var isCompleted = false
    
    public var player: Player
    public var movesPlayers: [Player:[GameboardPosition]] = [:]
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
        movesPlayers = gameViewController?.movesPlayers ?? [:]
        var i = 0; var j = 0
        for _ in (0...9) {
            switch player {
            case .first:
                let position = movesPlayers[player]![i]
                self.gameViewController?.firstPlayerTurnLabel.isHidden = false
                self.gameViewController?.secondPlayerTurnLabel.isHidden = true
                addMark(at: position)
                player = player.next; i += 1
            case .second:
                let position = movesPlayers[player]![j]
                self.gameViewController?.firstPlayerTurnLabel.isHidden = true
                self.gameViewController?.secondPlayerTurnLabel.isHidden = false
                self.gameViewController?.secondPlayerTurnLabel.text = "2nd player"
                addMark(at: position)
                player = player.next; j += 1
            }
        }
        self.gameViewController?.winnerLabel.isHidden = true
        self.isCompleted = true
    }
    
    public func addMark(at position: GameboardPosition) {
        gameViewController?.gameModeSegmentControl.isEnabled = false
        guard
            let gameboardView = self.gameboardView
        else { return }
        
        if !gameboardView.canPlaceMarkView(at: position) {
            gameboardView.removeMarkView(at: position)
            gameboard?.removePlayer(at: position)
        }
        
        let markView: MarkView
        switch self.player {
        case .first:
            markView = XView()
        case .second:
            markView = OView()
        }
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            Log(.playerInput(player: self.player, position: position))
            self.gameboard?.setPlayer(self.player, at: position)
            self.gameboardView?.placeMarkView(markView, at: position)
      //  }
    }
}
