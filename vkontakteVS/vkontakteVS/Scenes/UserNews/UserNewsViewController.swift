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
    private var userNews = [News]()
    private var newsWithFullText = [Int]()
    private let networkService = NetworkServiceInplimentation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register cell
        tableView.register(UserNewsTableViewCell.self)
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
            guard let self = self else { return }
            self.userNews = newsItems?.items ?? [News]()
            print(newsItems ?? "Error")
            self.tableView.reloadData()
        })
    }
}

extension UserNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserNewsTableViewCell.self, for: indexPath)
        cell.tag = userNews[indexPath.row].id
        cell.configuration(currentNews: userNews[indexPath.row])
        //cell.setNews(cellModel: userNews[indexPath.row] as! NewsTableViewCellModel)
        return cell
    }
}

extension UserNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let cellViewModel = userNews[indexPath.row]
        return 250.0//cellViewModel.size?.hightCell ?? CGFloat(50.0)
    } 
}

extension UserNewsViewController: UserNewsTableViewCellDelegate {
    func newHeightCell(for cell: UserNewsTableViewCell) {
        newsWithFullText.append(cell.tag)
        //userNews = UserActualNews.getNewsFromUserGroups(with: newsWithFullText)
        tableView.reloadData()
    }
}
