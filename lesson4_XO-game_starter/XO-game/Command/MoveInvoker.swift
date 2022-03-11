//
//  MoveInvoker.swift
//  XO-game
//
//  Created by Home on 19.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

fileprivate final class MoveInvoker {

    // MARK: Singleton
    internal static let shared = MoveInvoker()

    // MARK: Private properties
    private var gameboard = Gameboard()
    private var gameboardView = GameboardView()
    var movesCommands: [MoveCommand] = []

    // MARK: Internal
    
    func addMoveCommand(_ moveCommand: MoveCommand) {
        self.movesCommands.append(moveCommand)
    }
    
    // MARK: Private
    func execute() {
        self.movesCommands.forEach { move in move.execute() }
        self.movesCommands = []
    }
}

func executeMovesIfNeeded() {
    guard MoveInvoker.shared.movesCommands.count == 10 else {
        return
    }
    MoveInvoker.shared.execute()
}

func Move(player: Player, position: GameboardPosition, gameboard: Gameboard, gameboardView: GameboardView) {
    let move = MoveCommand(player: player, position: position, gameboard: gameboard, gameboardView: gameboardView)
    MoveInvoker.shared.addMoveCommand(move)
}
