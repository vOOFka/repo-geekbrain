//
//  SearchModuleBuilder.swift
//  iOSArchitecturesDemo
//
//  Created by Stanislav Belykh on 27.12.2021.
//  Copyright © 2021 ekireev. All rights reserved.
//

import UIKit

final class SearchModuleBuilder {

	func build() -> UIViewController {
		let presenter = SearchPresenter()
		let viewController = SearchViewController(presenter: presenter)
		presenter.viewInput = viewController
		return viewController
	}
}
