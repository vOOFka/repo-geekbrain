//
//  MusicDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class MusicDetailViewController: UIViewController {
    
    private var musicDetailView: MusicDetailView {
        return self.view as! MusicDetailView
    }
    private var viewModel: MusicDetailViewModel

    init(viewModel: MusicDetailViewModel) {
        self.viewModel = viewModel
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
        self.bindViewModel()
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
        self.viewModel.downloadImage()
        self.musicDetailView.playButton.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func playButtonAction(_ sender: UIButton) {
        self.viewModel.didTapPlaySong()
    }
    
    private func bindViewModel() {
        // Во время загрузки данных показываем индикатор загрузки
        self.viewModel.playProgress.addObserver(self) { [weak self] (isLoading, _) in
            if (self?.viewModel.isPlaying.value == true) {
                guard
                    let song = self?.viewModel.playingSong,
                    let progressView = self?.musicDetailView.progressView,
                    let currentProgress = self?.viewModel.playProgress.value
                else { return }
                
                switch song.playState {
                case .notStarted:
                    progressView.setProgress(0.0, animated: true)
                case .inProgress(_):
                    DispatchQueue.main.async {                        
                        print("percent complete: \(Float(currentProgress))")
                        progressView.setProgress(Float(currentProgress), animated: true)
                    }
                case .PlayEnded:
                    progressView.setProgress(0.0, animated: true)
                 }
            }
        }
        // Если пришла ошибка, то отобразим ее в виде алерта
        self.viewModel.error.addObserver(self) { [weak self] (error, _) in
            if let error = error {
                self?.showError(error: error)
            }
        }
        self.viewModel.image.addObserver(self) { [weak self] (image, _) in
            self?.musicDetailView.imageView.image = image
        }
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
}
