//
//  GameSessionCaretaker.swift
//  MillionVS
//
//  Created by Home on 06.12.2021.
//

import UIKit

final class GameSessionCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "gameSessions"
    
    func save(gameSessions: [GameSession]) {
        do {
            let data = try self.encoder.encode(gameSessions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveRecords() -> [GameSession] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([GameSession].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}
