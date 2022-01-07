//
//  MusicDetailViewModel.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 07.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class MusicDetailViewModel {
    
    // MARK: - Observable properties
    var isPlaying = Observable<Bool>(false)
    let error = Observable<Error?>(nil)
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    var song: ITunesSong
    var image = Observable<UIImage?>(nil)
    var playProgress = Observable<Double?>(0.0)
    var playingSong: PlayingSong?
    
    private var playSongsService: PlaySongsServiceInterface
    private let imageDownloader = ImageDownloader()
    
    // MARK: - Init
    
    init(song: ITunesSong, playSongsService: PlaySongsServiceInterface) {
        self.song = song
        self.playSongsService = playSongsService
        self.playSongsService.onProgressUpdate = { [weak self] currentProgress in
            self?.playProgress.value = currentProgress
        }
    }
    
    // MARK: - ViewModel methods
    
    func didTapPlaySong() {
        self.isPlaying.value = true
        self.playSongsService.startPlaySong(song)
        self.playingSong = playSongsService.playingSongs.first(where: { $0.song.trackName == song.trackName })
    }
    
    // MARK: - Private
    
    func downloadImage() {
        guard let url = self.song.artwork else { return }
        self.imageDownloader.getImage(fromUrl: url) { [weak self] (image, _) in
            self?.image.value = image
        }
    }
}
