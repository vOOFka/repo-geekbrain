//
//  ViewController.swift
//  vkontakteVS
//
//  Created by Home on 19.07.2021.
//

import UIKit

class LoginFormViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak private var loginTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    @IBOutlet weak private var enterButton: UIButton!
    
    @IBOutlet weak private var authScrollView: UIScrollView!
    
    //MARK: Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //registerKeyboardNotifications()
        hideKeyboardGestre()
    }
    
    deinit {
        //removeNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removeNotifications()
    }
    
    //MARK: Functions
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideKeyboardGestre () {
        let hideKeyboardGestre = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        authScrollView?.addGestureRecognizer(hideKeyboardGestre)
    }

    @objc func keyboardShow (_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsert = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10, right: 0)
        
        authScrollView.contentInset = contentInsert
        authScrollView.scrollIndicatorInsets = contentInsert
        authScrollView.scrollRectToVisible(enterButton.frame, animated: true)
    }
    
    @objc func keyboardHide () {
        authScrollView.contentInset = .zero
    }
    
    @objc func hideKeyboard () {
        self.authScrollView?.endEditing(true)
    }
    
    func checkAuth() -> Bool {
        let login = loginTextField.text!
        let pass  = passwordTextField.text!
//        var authResult: String { (login == "" && pass == "") ? "Пользователь авторизовался": "Ошибка авторизации"}
//        print(authResult)
        return (login == "" && pass == "") ? true : false

    }
    
    func showAuthError() {
        let alertMsg = UIAlertController(title: "Ошибка авторизации", message: "Неверный логин или пароль", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertMsg.addAction(closeAction)
        self.present(alertMsg, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "showMainScreenID" && checkAuth()) {
           return true
        } else {
            showAuthError()
            loginTextField.text = ""
            passwordTextField.text = ""
            
            return false
        }
    }
    
    //MARK: Actions
    @IBAction func enterButton(_ sender: Any) {

    }
}

