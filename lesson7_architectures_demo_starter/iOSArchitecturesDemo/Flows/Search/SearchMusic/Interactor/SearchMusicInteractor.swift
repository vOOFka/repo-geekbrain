//
//  SearchMusicInteractor.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchMusicInteractorInput {
    func requestSongs(with query: String, completion: @escaping (Result<[ITunesSong]>) -> Void)
}

final class SearchMusicInteractor: SearchMusicInteractorInput {
    private let searchService = ITunesSearchService()
    private var cacheSongs = Dictionary<String, Result<[ITunesSong]>>()
    
    func requestSongs(with query: String, completion: @escaping (Result<[ITunesSong]>) -> Void) {
        let cacheData = cacheSongs.contains(where: { $0.key == query })
        if cacheData {
            completion(cacheSongs[query]!)
        } else {
            self.searchService.getSongs(forQuery: query, completion: { songs in
                completion(songs)
                self.cacheSongs[query] = songs
            })
        }
        if cacheSongs.count >= 100 {
            cacheSongs.removeAll()
        }
    }
}
