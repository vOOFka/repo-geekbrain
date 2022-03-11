//
//  GameState.swift
//  XO-game
//
//  Created by Stanislav Belykh on 09.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

public protocol GameState {

	var isCompleted: Bool { get }

	func begin()

	func addMark(at position: GameboardPosition)
}
