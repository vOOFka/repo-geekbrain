//
//  WhatsNewViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 01.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class WhatsNewViewController: UIViewController {

    // MARK: - Properties

    private let app: ITunesApp

    private var appWhatsNewView: WhatsNewView {
        return self.view as! WhatsNewView
    }

    // MARK: - Init

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
        self.view = WhatsNewView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
    }

    // MARK: - Private

    private func fillData() {
        self.appWhatsNewView.versionLabel.text = "Версия " + (app.version ?? "")
        self.appWhatsNewView.releaseDateLabel.text = app.currentVersionReleaseDate
        self.appWhatsNewView.whatsNewLabel.text = app.releaseNotes
    }
}
