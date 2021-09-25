//
//  UITableView+Ext.swift
//  vkontakteVS
//
//  Created by Home on 25.09.2021.
//

import UIKit

extension UITableView {
    func updateTableView(deletions: [Int], insertions: [Int], modifications: [Int], sections: [Int]) {
        for section in sections {
        beginUpdates()
            deleteRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .fade)
            insertRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .fade)
            reloadRows(at: deletions.map{ IndexPath(row: $0, section: section) }, with: .automatic)
        endUpdates()
        }
    }
}
