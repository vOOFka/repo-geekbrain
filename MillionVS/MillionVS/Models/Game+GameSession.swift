//
//  Game+GameSession.swift
//  MillionVS
//
//  Created by Home on 05.12.2021.
//

import Foundation

class Game {
    static let shared = Game()
    var gameSession: GameSession?
    private(set) var topScores: [GameSession] = [] {
        didSet {
            gameSessionCaretaker.save(gameSessions: self.topScores)
        }
    }
    private let gameSessionCaretaker = GameSessionCaretaker()
    var selectedDifficulty: Difficulty = .easy
    
    private init() {
        self.topScores = self.gameSessionCaretaker.retrieveRecords()
    }
    
    func addScore(_ score: GameSession) {
        self.topScores.append(score)
    }
    
    func clearScores() {
        self.topScores = []
    }
}

class GameSession: Codable {
    var correctAnswerds = 0
    var questionCount = 0
    var scores = 0
}
