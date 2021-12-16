//
//  Player.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public enum Player: CaseIterable, Equatable {
    public static var allCases: [Player] {
        return [.first(gameMode: nil), .second, .cpu]
    }    
    case first(gameMode: String?)
    case second
    case cpu
    
    var next: Player {
        switch self {
        case .first(let gameMode) where gameMode == "CPU": return .cpu
        case .first: return .second
        case .second, .cpu: return .first(gameMode: nil)
        }
    }

	var markViewPrototype: MarkView {
		switch self {
        case .second, .cpu: return OView()
        case .first(gameMode: .some(_)), .first(gameMode: .none):
            return XView()
        }
	}
}
