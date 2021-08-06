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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Header of cell
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        //private news = getNewsFromUserGroups()
    }
}

extension UserNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? UserNewsTableViewCell else {
            fatalError("Message: Error in dequeue UserNewsTableViewCell")
        }
        return cell
    }
}

extension UserNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    private func getNewsFromUserGroups () -> [NewsTableViewCellModel] {
        var actualNewsArray = [NewsTableViewCellModel]()
        let userGroups = Group.userGroups
        let someNews = News.someNews
        
        for news in someNews {
            for group in userGroups {
                if group.groupId == news.groupId {
//                    actualNewsArray.append(ActualNews(group: group, date: news.date, text: news.text, image: news.image, likes: news.likes, comments: comm, repost: <#T##String#>, views: <#T##String#>))
                }
                
            }
            
        }
                        
        
        
        return actualNewsArray
    }
    
}
