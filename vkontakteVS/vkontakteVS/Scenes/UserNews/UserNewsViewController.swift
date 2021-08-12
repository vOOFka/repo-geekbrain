//
//  UserNewsViewController.swift
//  vkontakteVS
//
//  Created by Admin on 05.08.2021.
//

import UIKit

class UserNewsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Var
    private let cellID = "UserNewsTableViewCell"
    private var news = UserActualNews.getNewsFromUserGroups()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register cell
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.backgroundColor = #colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)
    }
}

extension UserNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserNewsTableViewCell else {
            fatalError("Message: Error in dequeue UserNewsTableViewCell")
        }
        cell.setNews(cellModel: news[indexPath.row])
        return cell
    }
}

extension UserNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = news[indexPath.row]
        return cellViewModel.size.hightCell
    } 
}
