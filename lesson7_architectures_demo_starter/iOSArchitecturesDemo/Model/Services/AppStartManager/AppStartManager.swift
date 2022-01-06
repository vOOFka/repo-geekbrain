//
//  AppStartConfigurator.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 19.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class AppStartManager {
    
    var window: UIWindow?
	let builder = SearchModuleBuilder()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
		let rootVCApp = builder.buildAppVC()
        rootVCApp.navigationItem.title = "Search app via iTunes"
        
        let navVCApp = self.configuredAppNavigationController
        navVCApp.viewControllers = [rootVCApp]
        navVCApp.title = "Search for applications"
        
        let rootVCMusic = builder.buildMusicVC()
        rootVCMusic.navigationItem.title = "Search songs via iTunes"
        
        let navVCMusic = self.configuredMusicNavigationController
        navVCMusic.viewControllers = [rootVCMusic]
        navVCMusic.title = "Search for music"
        
        let tabbarVC = self.tabbarViewController
        tabbarVC.setViewControllers([navVCApp, navVCMusic], animated: true)
        
        guard let items = tabbarVC.tabBar.items else { return }
        if items.count >= 2 {
                items[0].image = UIImage(systemName: "applelogo")
                items[1].image = UIImage(systemName: "music.note.list")
        }
        
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
    }
    
    private lazy var configuredAppNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        navVC.navigationBar.barTintColor = UIColor.varna
        navVC.navigationBar.isTranslucent = false
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navVC
    }()
    
    private lazy var configuredMusicNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        navVC.navigationBar.barTintColor = UIColor.varna
        navVC.navigationBar.isTranslucent = false
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navVC
    }()
    
    private lazy var tabbarViewController: UITabBarController = {
            let tabbarViewController = UITabBarController()
            tabbarViewController.tabBar.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return tabbarViewController
    }()
}
