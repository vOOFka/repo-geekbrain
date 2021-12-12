//
//  UIViewController+Ext.swift
//  vkontakteVS
//
//  Created by Home on 25.09.2021.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        let alertVC = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertVC.addAction(okButton)
        present(alertVC, animated: true, completion: nil)
    }
}
