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
    private var userNews = NewsFeed()
    private var newsWithFullText = [Int]()
    private let networkService = NetworkServiceInplimentation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(NewsHeader.self)
        //register cell
        tableView.register(UserNewsTableViewCellSecond.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        //Show News from VK API
        updateNewsFromVKAPI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK: - Functions
    fileprivate func updateNewsFromVKAPI() {
        networkService.getNewsfeed(completion: { [weak self] newsItems in
            guard let self = self, let newsFeed = newsItems else { return }
            self.userNews = newsFeed
            self.tableView.reloadData()
        })
    }
}

extension UserNewsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { userNews.items.count }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 80.0 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(NewsHeader.self, viewForHeaderInSection: section)
        let currentNews = userNews.items[section]
        let groupNews = userNews.groups.first(where: { $0.id == 0 - currentNews.sourceId })
        header.configuration(currentNews: currentNews, currentGroupNews: groupNews)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNews.items[section].attachments?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserNewsTableViewCellSecond.self, for: indexPath)
        //let currentNews = userNews[indexPath.row]
        //let groupNews = currentNews.groups?.firstIndex(where: { $0.id == 0 - currentNews.id })
//        cell.tag = userNews[indexPath.row].id
//        cell.configuration(currentNews: userNews[indexPath.row])
        //cell.setNews(cellModel: userNews[indexPath.row] as! NewsTableViewCellModel)
        return cell
    }
}

extension UserNewsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //let cellViewModel = userNews[indexPath.row]
//        return 250.0//cellViewModel.size?.hightCell ?? CGFloat(50.0)
//    }
}

extension UserNewsViewController: UserNewsTableViewCellDelegate {
    func newHeightCell(for cell: UserNewsTableViewCell) {
//        newsWithFullText.append(cell.tag)
//        //userNews = UserActualNews.getNewsFromUserGroups(with: newsWithFullText)
//        tableView.reloadData()
    }
}
