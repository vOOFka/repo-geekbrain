//
//  MoveAction.swift
//  XO-game
//
//  Created by Home on 19.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class MoveAction {
    var player: Player
    var position: GameboardPosition
    var gameboard: Gameboard

    init(player: Player, position: GameboardPosition, gameboard: Gameboard) {
        self.player = player
        self.position = position
        self.gameboard = gameboard
    }
    public func execute(_ gameboard: Gameboard, gameboardView: GameboardView) {
        guard
            gameboardView.canPlaceMarkView(at: position)
        else { return }
        gameboard.setPlayer(self.player, at: self.position)
        addMark(at: self.position, gameboardView: gameboardView)
    }
    
    private func addMark(at position: GameboardPosition, gameboardView: GameboardView) {
        let markView: MarkView
        switch self.player {
        case .first:
            markView = XView()
        case .second:
            markView = OView()
        }
        
       // Log(.playerInput(player: player, position: position))
        gameboardView.placeMarkView(markView, at: position)
    }
}
