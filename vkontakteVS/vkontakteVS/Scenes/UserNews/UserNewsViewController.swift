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
    lazy private var news = UserActualNews.getNewsFromUserGroups(with: newsWithFullText)
    private var newsWithFullText = [Int]() 
    override func viewDidLoad() {
        super.viewDidLoad()
        //register cell
        tableView.register(UserNewsTableViewCell.self)
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
        let cell = tableView.dequeueReusableCell(UserNewsTableViewCell.self, for: indexPath)
        cell.delegate = self
        cell.tag = news[indexPath.row].newsId
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

extension UserNewsViewController: UserNewsTableViewCellDelegate {
    func newHeightCell(for cell: UserNewsTableViewCell) {
        newsWithFullText.append(cell.tag)
        news = UserActualNews.getNewsFromUserGroups(with: newsWithFullText)
        tableView.reloadData()
    }
}
