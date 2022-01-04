//
//  AppDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 20.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class AppDetailViewController: UIViewController {
    
	let app: ITunesApp
	private let imageDownloader = ImageDownloader()

	lazy var headerViewController = AppDetailHeaderViewController(app: self.app)
    lazy var whatsNewViewController = WhatsNewViewController(app: self.app)
    lazy var screenshotsViewController = ScreenshotsController(app: self.app)
    
    private var appDetailView: AppDetailView {
        return self.view as! AppDetailView
    }

	init(app: ITunesApp) {
		self.app = app
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		self.configureUI()
    }
    
    // MARK: - Private

	private func configureUI() {
		self.view.backgroundColor = .white
		self.navigationController?.navigationBar.tintColor = UIColor.white;
		self.navigationItem.largeTitleDisplayMode = .never
		self.addHeaderViewController()
        self.addWhatsNewViewController()
        self.addScreenScreenshotsVC()        
		//self.addDescriptionViewController()
        
	}
    
    private func configureNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
    }

	private func addHeaderViewController() {
		self.addChild(self.headerViewController)
		self.view.addSubview(self.headerViewController.view)
		self.headerViewController.didMove(toParent: self)

		self.headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.headerViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			self.headerViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			self.headerViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
		])
	}
    
    private func addWhatsNewViewController() {
        self.addChild(self.whatsNewViewController)
        self.view.addSubview(self.whatsNewViewController.view)
        self.whatsNewViewController.didMove(toParent: self)

        self.whatsNewViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.whatsNewViewController.view.topAnchor.constraint(equalTo: self.headerViewController.view.bottomAnchor),
            self.whatsNewViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.whatsNewViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    private func addScreenScreenshotsVC() {
        self.addChild(self.screenshotsViewController)
        self.view.addSubview(self.screenshotsViewController.view)
        self.screenshotsViewController.didMove(toParent: self)

        self.screenshotsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.screenshotsViewController.view.topAnchor.constraint(equalTo: self.whatsNewViewController.view.bottomAnchor),
            self.screenshotsViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.screenshotsViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

	private func addDescriptionViewController() {
		// TODO: ДЗ, сделать другие сабмодули
		let descriptionViewController = UIViewController()

		self.addChild(descriptionViewController)
		self.view.addSubview(descriptionViewController.view)
		descriptionViewController.didMove(toParent: self)

		descriptionViewController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			descriptionViewController.view.topAnchor.constraint(equalTo: self.headerViewController.view.bottomAnchor),
			descriptionViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			descriptionViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
			descriptionViewController.view.heightAnchor.constraint(equalToConstant: 250.0)
		])
	}

}
