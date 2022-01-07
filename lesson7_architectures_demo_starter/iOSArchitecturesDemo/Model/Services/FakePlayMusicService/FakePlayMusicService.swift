//
//  FakePlayMusicService.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 07.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import Foundation

protocol PlaySongsServiceInterface {
    var playingSongs: [PlayingSong] { get }
    var onProgressUpdate: ((Double) -> Void)? { get set }
    func startPlaySong(_ song: ITunesSong)
}

final class PlayingSong {
    enum PlayState {
        case notStarted
        case inProgress(progress: Double)
        case PlayEnded
    }
    
    let song: ITunesSong
    
    var playState: PlayState = .notStarted
    
    init(song: ITunesSong) {
        self.song = song
    }
}

final class FakePlaySongsService: PlaySongsServiceInterface {
    
    // MARK: - PlaySongsServiceInterface
    
    private(set) var playingSongs: [PlayingSong] = []
    
    var onProgressUpdate: ((Double) -> Void)?
    
    func startPlaySong(_ song: ITunesSong) {
        let playingSong = PlayingSong(song: song)
        if !self.playingSongs.contains(where: { $0.song.trackName == song.trackName }) {
            self.playingSongs.append(playingSong)
            self.startTimer(for: playingSong)
        }
    }
    
    // MARK: - Private properties
    
    private var timers: [Timer] = []
    
    // MARK: - Private
    
    private func startTimer(for playingSong: PlayingSong) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            var currentProgress: Double = 0.0
            switch playingSong.playState {
            case .notStarted:
                playingSong.playState = .inProgress(progress: 0.0)
            case .inProgress(let progress):
                let newProgress = progress + 1.0
                if newProgress >= (playingSong.song.trackTime / 1000) {
                    playingSong.playState = .PlayEnded
                    self?.invalidateTimer(timer)
                } else {
                    playingSong.playState = .inProgress(progress: progress + 1.0)
                    currentProgress = self?.calcProgressPercent(progress: (progress + 1.0), trackTime: playingSong.song.trackTime) ?? 0.0
                }
            case .PlayEnded:
                self?.invalidateTimer(timer)
            }
            self?.onProgressUpdate?(currentProgress)
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timers.append(timer)
    }
    
    private func invalidateTimer(_ timer: Timer) {
        timer.invalidate()
        self.timers.removeAll { $0 === timer }
    }
    
    private func calcProgressPercent(progress: Double, trackTime: Double) -> Double {
        let trackTime = trackTime / 1000
        return ((100 * progress) / trackTime) / 100
    }
}
