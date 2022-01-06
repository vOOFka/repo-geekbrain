//
//  SearchModuleBuilder.swift
//  iOSArchitecturesDemo
//
//  Created by Stanislav Belykh on 27.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit

final class SearchModuleBuilder {

	func buildAppVC() -> UIViewController {
		let presenter = SearchPresenter()
		let viewController = SearchViewController(presenter: presenter)
		presenter.viewInput = viewController
		return viewController
	}
    
    func buildMusicVC() -> UIViewController {
        let router = SearchMusicRouter()
        let interactor = SearchMusicInteractor()
        let presenter = SearchMusicPresenter(interactor: interactor, router: router)
        let viewController = SearchMusicViewController(presenter: presenter)
        presenter.viewInput = viewController
        router.viewController = viewController
        return viewController
    }
}
