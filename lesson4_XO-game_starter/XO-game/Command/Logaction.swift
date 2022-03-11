//
//  Logaction.swift
//  XO-game
//
//  Created by Stanislav Belykh on 09.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

enum LogAction {

	case playerInput(player: Player, position: GameboardPosition)

	case gameFinished(winner: Player?)

	case restartGame
}
