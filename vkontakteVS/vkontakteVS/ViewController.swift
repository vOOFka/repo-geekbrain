//
//  ViewController.swift
//  vkontakteVS
//
//  Created by Home on 19.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var authScrollView: UIScrollView!
    
    //MARK: Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyBoardNotifications()
    }
    
    deinit {
        removeNotifications()
    }
    
    //MARK: Functions
    func registerKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyBoardShow (_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyBoardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsert = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardSize.height + 10, right: 0)
        //authScrollView.contentOffset = CGPoint(x: 0, y: keyBoardSize.height + 10)
        
        authScrollView.contentInset = contentInsert
        authScrollView.scrollIndicatorInsets = contentInsert
        authScrollView.scrollRectToVisible(enterButton.frame, animated: true)
    }
    
    @objc func keyBoardHide () {
        //authScrollView.contentOffset = CGPoint.zero
        authScrollView.contentInset = .zero
    }    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    //MARK: Actions
    @IBAction func enterButton(_ sender: Any) {
        print("Action")
    }

}

