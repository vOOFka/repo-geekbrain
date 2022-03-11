//
//  MoveCommand.swift
//  XO-game
//
//  Created by Home on 19.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

final class MoveCommand {
    var player: Player
    var position: GameboardPosition
    var gameboard: Gameboard
    var gameboardView: GameboardView

    init(player: Player, position: GameboardPosition, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.position = position
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    public func execute() {
        guard
            gameboardView.canPlaceMarkView(at: position)
        else { return }
        gameboard.setPlayer(self.player, at: self.position)
        addMark()
    }
    
    private func addMark() {
        let markView: MarkView
        switch self.player {
        case .first:
            markView = XView()
        case .second:
            markView = OView()
        }
        gameboardView.placeMarkView(markView, at: position)
    }
}
