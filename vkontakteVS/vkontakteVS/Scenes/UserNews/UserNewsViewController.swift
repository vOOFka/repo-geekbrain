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
    //private let
    //private let
    private let cellID = "UserNewsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
}

extension UserNewsViewController: UITableViewDelegate, UITableViewDataSource {
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
