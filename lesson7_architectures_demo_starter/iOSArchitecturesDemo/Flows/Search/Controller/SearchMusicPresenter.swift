//
//  SearchMusicPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class SearchMusicPresenter {

    private let searchService = ITunesSearchService()
    weak var viewInput: (UIViewController & SearchMusicViewInput)?

    private func requestSongs(with query: String) {
        self.searchService.getSongs(forQuery: query) { [weak self] result in
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
                    self.showError(error: $0)
                }
        }
    }

    private func openSongDetails(with song: ITunesSong) {
        let musicDetaillViewController = MusicDedailViewController(song: song)
        self.viewInput?.navigationController?.pushViewController(musicDetaillViewController, animated: true)
    }

    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.viewInput?.present(alert, animated: true, completion: nil)
    }
}

// MARK: - SearchViewOutput
extension SearchMusicPresenter: SearchMusicViewOutput {
    func viewDidSelectSong(_ song: ITunesSong) {
        self.openSongDetails(with: song)
    }

    func viewDidSearch(with query: String) {
        self.requestSongs(with: query)
    }
}
