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
        tableView.estimatedRowHeight = 200
      //  tableView.rowHeight = UITableView.automaticDimension
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 80.0 }
    
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
        //footer.configuration(currentNews: currentNews, currentGroupNews: groupNews)
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
            cell.configuration(currentNews: currentNews)
            cell.delegate = self
            return cell
        } else {
            guard let currentAttachment = currentNews.attachments else { return UITableViewCell.init(style: .default, reuseIdentifier: "")}
            var indexAttachment = indexPath.row - 1
            if indexAttachment < 0 { indexAttachment = 0 }
            if currentAttachment.count == 1 {
                let cell = tableView.dequeueReusableCell(NewsImageCell.self, for: indexPath)
                cell.configuration(currentAttachment: currentAttachment[indexAttachment])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(NewsImgGalleryTableViewCell.self, for: indexPath)
                cell.configure(with: currentAttachment)
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
            return 300.0
            //return UITableView.automaticDimension
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
