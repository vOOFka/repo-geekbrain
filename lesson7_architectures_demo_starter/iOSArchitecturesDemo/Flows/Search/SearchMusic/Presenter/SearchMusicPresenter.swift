//
//  SearchMusicPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class SearchMusicPresenter {
    weak var viewInput: (UIViewController & SearchMusicViewInput)?
    
    let interactor: SearchMusicInteractorInput
    let router: SearchMusicRouterInput
    
    init(interactor: SearchMusicInteractorInput, router: SearchMusicRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    private func requestSongs(with query: String) {
        self.interactor.requestSongs(with: query) { [weak self] result in
            guard let self = self else { return }
            result
                .withValue { songs in
                    guard !songs.isEmpty else {
                        self.viewInput?.showNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchMusicResults = songs
                }
                .withError {
                    self.router.showError(error: $0)
                }
        }
    }
}

// MARK: - SearchViewOutput
extension SearchMusicPresenter: SearchMusicViewOutput {
    func viewDidSelectSong(_ song: ITunesSong) {
        self.router.openSongDetails(with: song)
    }

    func viewDidSearch(with query: String) {
        self.requestSongs(with: query)
    }
}
