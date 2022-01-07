//
//  SearchMusicRouter.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

protocol SearchMusicRouterInput {
    func openSongDetails(with song: ITunesSong)
    func openSongInITunes(_ song: ITunesSong)
    func showError(error: Error)
}

final class SearchMusicRouter: SearchMusicRouterInput {
    weak var viewController: UIViewController?

    func openSongDetails(with song: ITunesSong) {
        let musicDetailViewModel = MusicDetailViewModel(song: song, playSongsService: FakePlaySongsService())
        let musicDetaillViewController = MusicDetailViewController(viewModel: musicDetailViewModel)
        self.viewController?.navigationController?.pushViewController(musicDetaillViewController, animated: true)
    }

    func openSongInITunes(_ song: ITunesSong) {
        let musicDetailViewModel = MusicDetailViewModel(song: song, playSongsService: FakePlaySongsService())
        let musicDetaillViewController = MusicDetailViewController(viewModel: musicDetailViewModel)
        self.viewController?.navigationController?.pushViewController(musicDetaillViewController, animated: true)
        
//        guard let urlString = app.appUrl, let url = URL(string: urlString) else {
//            return
//        }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }

    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
