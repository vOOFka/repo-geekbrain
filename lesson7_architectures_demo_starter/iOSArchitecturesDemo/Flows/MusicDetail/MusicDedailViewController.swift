//
//  MusicDedailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class MusicDedailViewController: UIViewController {

    let song: ITunesSong
    private let imageDownloader = ImageDownloader()
    
    private var musicDetailView: MusicDetailView {
        return self.view as! MusicDetailView
    }

    init(song: ITunesSong) {
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = MusicDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.fillData()
    }
    
    // MARK: - Private

    private func configureUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func fillData() {
        self.downloadImage()
    }

    private func downloadImage() {
        guard let url = self.song.artwork else { return }
        self.imageDownloader.getImage(fromUrl: url) { [weak self] (image, _) in
            self?.musicDetailView.imageView.image = image
        }
    }
}
