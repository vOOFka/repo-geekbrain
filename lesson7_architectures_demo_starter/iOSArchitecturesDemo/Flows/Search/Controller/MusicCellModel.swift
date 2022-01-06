//
//  MusicCellModel.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation

struct MusicCellModel {
    let title: String
    let subtitle: String?
    let collection: String?
    let artwork: String?
}

final class MusicCellModelFactory {
    
    static func cellModel(from model: ITunesSong) -> MusicCellModel {
        return MusicCellModel(title: model.trackName,
                              subtitle: model.artistName,
                              collection: model.collectionName,
                              artwork: model.artwork >>- { "\($0)" })
    }
}
