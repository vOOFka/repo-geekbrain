//
//  SearchPresenter.swift
//  iOSArchitecturesDemo
//
//  Created by Stanislav Belykh on 27.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit

final class SearchPresenter {

	private let searchService = ITunesSearchService()
	weak var viewInput: (UIViewController & SearchViewInput)?

	private func requestApps(with query: String) {
		self.searchService.getApps(forQuery: query) { [weak self] result in
			guard let self = self else { return }
			self.viewInput?.throbber(show: false)
			result
				.withValue { apps in
					guard !apps.isEmpty else {
						self.viewInput?.showNoResults()
						return
					}
					self.viewInput?.hideNoResults()
					self.viewInput?.searchResults = apps
				}
				.withError {
					self.showError(error: $0)
				}
		}
	}

	private func openAppDetails(with app: ITunesApp) {
		let appDetaillViewController = AppDetailViewController(app: app)
		self.viewInput?.navigationController?.pushViewController(appDetaillViewController, animated: true)
	}

	private func showError(error: Error) {
		let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
		let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(actionOk)
		self.viewInput?.present(alert, animated: true, completion: nil)
	}
}

// MARK: - SearchViewOutput
extension SearchPresenter: SearchViewOutput {

	func viewDidSearch(with query: String) {
		self.viewInput?.throbber(show: true)
		self.requestApps(with: query)
	}

	func viewDidSelectApp(_ app: ITunesApp) {
		self.openAppDetails(with: app)
	}
}
