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
    //MARK: - Properties
    private var userNews = NewsFeed()
    private var currentNews = News()
    private var newsWithFullText = [Int]()
    private let networkService = NetworkServiceImplimentation()
    private var needMoreTextBtn = [IndexPath : Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(NewsHeader.self)
        //register cells
        tableView.registerClass(NewsTextCell.self)
        tableView.registerClass(NewsImageCell.self)
        tableView.register(NewsImgGalleryTableViewCell.self)
        //register Footer of cell
        tableView.register(NewsFooter.self)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        //Show News from VK API
        updateNewsFromVKAPI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Show News from VK API
        updateNewsFromVKAPI()
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 90.0 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 90.0 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(NewsHeader.self, viewForHeaderInSection: section)
        currentNews = userNews.items[section]
        let groupNews = userNews.groups.first(where: { $0.id == 0 - currentNews.sourceId })
        header.configuration(currentNews: currentNews, currentGroupNews: groupNews)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(NewsFooter.self, viewForHeaderInSection: section)
        currentNews = userNews.items[section]
        footer.configure(with: currentNews)
        return footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = userNews.items[section]
        var count: Int = currentSection.countCellItems
        if currentSection.text.isEmpty { count = count - 1 }
        //count = count + (currentSection.attachments?.count ?? 0)
        count = count + 1
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentNews = userNews.items[indexPath.section]
        if indexPath.row == 0 && !currentNews.text.isEmpty {
            let cell = tableView.dequeueReusableCell(NewsTextCell.self, for: indexPath)
            cell.configuration(for: currentNews.text)
            cell.delegate = self
            return cell
        } else {
            guard let urls = currentNews.photosURLs,
                  let ratios = currentNews.ratios
            else { return UITableViewCell() }
            if urls.count == 1 {
                let cell = tableView.dequeueReusableCell(NewsImageCell.self, for: indexPath)
                cell.configuration(for: urls[0])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(NewsImgGalleryTableViewCell.self, for: indexPath)
                cell.configuration(for: urls, with: ratios)
                return cell
            }
        }
    }
}

extension UserNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentNews = userNews.items[indexPath.section]
        if indexPath.row == 0 && !currentNews.text.isEmpty {
            let height = NewsCellSizeCalculator().hightTextCell(newsText: currentNews.text)
            return height
        } else {
            guard let urls = currentNews.photosURLs,
                  let ratios = currentNews.ratios,
                  !(urls.isEmpty && ratios.isEmpty) else { return 0 }
            if urls.count == 1 {
                let height = ratios[0] * view.frame.width
                return height
            } else {
                let height = ratios[0] * view.frame.width
                return height
            }
        }        
    }
}

extension UserNewsViewController: NewsTextCellDelegate {  
    func newHeightCell(for cell: NewsTextCell) {
        print("123")
        
    }
   
 //   func newHeightCell(for cell: UserNewsTableViewCell) {
//        newsWithFullText.append(cell.tag)
//        //userNews = UserActualNews.getNewsFromUserGroups(with: newsWithFullText)
//        tableView.reloadData()
 //   }
}
