//
//  GameEndedState.swift
//  XO-game
//
//  Created by Stanislav Belykh on 09.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

public class GameEndedState: GameState {

	public let isCompleted = false

	public let winner: Player?
	private(set) weak var gameViewController: GameViewController?

	init(winner: Player?, gameViewController: GameViewController) {
		self.winner = winner
		self.gameViewController = gameViewController
	}

	public func begin() {
		Log(.gameFinished(winner: self.winner))
		self.gameViewController?.winnerLabel.isHidden = false
		if let winner = winner {
			self.gameViewController?.winnerLabel.text = self.winnerName(from: winner) + " win"
		} else {
			self.gameViewController?.winnerLabel.text = "No winner"
		}
		self.gameViewController?.firstPlayerTurnLabel.isHidden = true
		self.gameViewController?.secondPlayerTurnLabel.isHidden = true
	}

	public func addMark(at position: GameboardPosition) { }

	private func winnerName(from winner: Player) -> String {
		switch winner {
		case .first: return "1st player"
		case .second: return "2nd player"
		}
	}
}
