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
    private let operationQueue: OperationQueue = {
    let operationQueue = OperationQueue()
        operationQueue.name = "com.AsyncOperation.UserNewsViewController"
        operationQueue.qualityOfService = .utility
        return operationQueue
    }()
    private var isLoading = false
    private var nextFrom = ""
    private var fullTextPosts = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        tableView.prefetchDataSource = self
        //Show News from VK API
        updateNewsFromVKAPI()
        //Refresh news...
        setupRefreshControl()
    }
    //MARK: - Functions
    fileprivate func updateNewsFromVKAPI() {
        networkService.getNewsfeed(completion: { [weak self] newsItems in
            guard let self = self, let newsFeed = newsItems else { return }
            self.userNews = newsFeed
            self.nextFrom = self.userNews.nextFrom ?? ""
            self.tableView.reloadData()
        })
    }
    fileprivate func registerCells() {
        //register Header of cell
        tableView.register(NewsHeader.self)
        //register cells
        tableView.registerClass(NewsTextCell.self)
        tableView.registerClass(NewsImageCell.self)
        tableView.register(NewsImgGalleryTableViewCell.self)
        //register Footer of cell
        tableView.register(NewsFooter.self)
    }
    fileprivate func setupRefreshControl() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white]
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление", attributes: attributes)
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        guard let date = userNews.items.first?.date
        else {
            tableView.refreshControl?.endRefreshing()
            return
        }
        let stringDate = String(date + 1) //добавляем сeкунду чтобы не грузилась уже существующая новость
        let request = networkService.getNewsfeedRequest(stringDate)
        let getData = AFGetDataOperation(request: request)
        let parseData = DataParsingOperation<NewsFeed>()
        let completionOperation = BlockOperation {
            guard let newsFromResponse = parseData.outputData else { self.tableView.refreshControl?.endRefreshing(); return }
            if newsFromResponse.items.count > 0 {
                self.userNews.items.insert(contentsOf: newsFromResponse.items, at: 0)
                self.userNews.groups.insert(contentsOf: newsFromResponse.groups, at: 0)
                self.tableView.reloadData()
            }
            self.tableView.refreshControl?.endRefreshing()
        }

        parseData.addDependency(getData)
        completionOperation.addDependency(parseData)

        operationQueue.addOperation(getData)
        operationQueue.addOperation(parseData)
        OperationQueue.main.addOperation(completionOperation)
    }
}

extension UserNewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > userNews.items.count - 3,
           !isLoading {
            isLoading = true
            let request = networkService.getNewsfeedRequest(nil, nextFrom: nextFrom)
            let getData = AFGetDataOperation(request: request)
            let parseData = DataParsingOperation<NewsFeed>()
            let completionOperation = BlockOperation {
                guard let newsFromResponse = parseData.outputData else { return }
                if newsFromResponse.items.count > 0 {
                    self.userNews.items.append(contentsOf: newsFromResponse.items)
                    self.userNews.groups.append(contentsOf: newsFromResponse.groups)
                    self.isLoading = false
                    self.nextFrom = newsFromResponse.nextFrom ?? ""
                    self.tableView.reloadData()
                }
            }
            parseData.addDependency(getData)
            completionOperation.addDependency(parseData)
            
            operationQueue.addOperation(getData)
            operationQueue.addOperation(parseData)
            OperationQueue.main.addOperation(completionOperation)
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > userNews.items.count - 5 {
            operationQueue.cancelAllOperations()
            //print("*****OPERATION CANCEL********")
        }
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
            if !fullTextPosts.contains(indexPath.section) {
                cell.moreTextButton.setTitle("Показать больше...", for: .normal)
            } else {
                cell.moreTextButton.setTitle("Свернуть...", for: .normal)
            }
            cell.configuration(for: currentNews.text, with: currentNews.sizes)
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
            guard let cellparam = currentNews.sizes else { return CGFloat(0) }
            if fullTextPosts.contains(indexPath.section) {
                return cellparam.hightFullCell
            }
            return cellparam.hightSmallCell
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
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if !fullTextPosts.contains(indexPath.section) {
            fullTextPosts.append(indexPath.section)
        } else {
            fullTextPosts.removeAll(where: { $0 == indexPath.section })
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
