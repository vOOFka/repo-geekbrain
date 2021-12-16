//
//  Command.swift
//  XO-game
//
//  Created by Stanislav Belykh on 09.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

final class LogCommand {

	let action: LogAction

	init(action: LogAction) {
		self.action = action
	}

	var logMessage: String {
		switch self.action {
		case .playerInput(let player, let position):
			return "\(player) placed mark at \(position)"
		case .gameFinished(let winner):
			if let winner = winner {
				return "\(winner) win game"
			} else {
				return "game finished with no winner"
			}
		case .restartGame:
			return "game restarted"
		}
	}
}
