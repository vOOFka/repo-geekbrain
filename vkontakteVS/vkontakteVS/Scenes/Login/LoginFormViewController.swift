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
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK: Properties
    private let transparancyCircleView = TransparancyCircleView()
    private var isLoading = false
    private let cloudView = Cloud()
    
    //MARK: Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //registerKeyboardNotifications()
        //Tree circle activity indicator
        //setupTransparancyCircleView()
        //transparancyCircleView.animate()
            
        //Cloud activity indicator
        setupCloudView()
        //cloudView.animationStart()
        
        //Animation Logo
        let tapRecognazer = UITapGestureRecognizer(target: self, action: #selector(tapOnLogo(_sender:)))
        logoImageView.addGestureRecognizer(tapRecognazer)
        animationLogo()
        
        //Login field default
        loginTextField.text = UserSession.shared.userName
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
    private func animationLogo() {
        let scale = CGAffineTransform(scaleX: 0.3, y: 2)
        let offsetY: CGFloat = logoImageView.frame.size.height + 30
        
        //self.logoImageView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/2).concatenating(scale)
        }, completion: {_ in
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY).concatenating(scale)
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.logoImageView.transform = .identity
            })
        })
    }
    
    private func setupTransparancyCircleView() {
        authScrollView.addSubview(transparancyCircleView)
        
        NSLayoutConstraint.activate([
            transparancyCircleView.centerYAnchor.constraint(equalTo: enterButton.centerYAnchor, constant: 100),
            transparancyCircleView.centerXAnchor.constraint(equalTo: authScrollView.centerXAnchor),
            transparancyCircleView.heightAnchor.constraint(equalToConstant: 40),
            transparancyCircleView.widthAnchor.constraint(equalToConstant: 90)
            ])
    }
    private func setupCloudView() {
        authScrollView.addSubview(cloudView)
        
        NSLayoutConstraint.activate([
            cloudView.centerYAnchor.constraint(equalTo: enterButton.centerYAnchor, constant: 100),
            cloudView.centerXAnchor.constraint(equalTo: authScrollView.centerXAnchor),
            cloudView.heightAnchor.constraint(equalToConstant: 80),
            cloudView.widthAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func hideKeyboardGestre () {
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
    
    private func checkAuth() -> Bool {
        let login = loginTextField.text!
        let pass  = passwordTextField.text!
//        var authResult: String { (login == "" && pass == "") ? "Пользователь авторизовался": "Ошибка авторизации"}
//        print(authResult)
        return (login == UserSession.shared.userName && pass == "") ? true : false
    }
    
    private func showAuthError() {
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
            loginTextField.text = UserSession.shared.userName
            passwordTextField.text = ""
            isLoading = false
            cloudView.animationStop()
            return false
        }
    }
    
    //MARK: Actions
    @objc private func tapOnLogo(_sender: UITapGestureRecognizer) {
        animationLogo()
    }
    
    @IBAction private func enterButton(_ sender: Any) {
        if isLoading != true {
            isLoading = true
            cloudView.animationStart()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                if self.shouldPerformSegue(withIdentifier: "showMainScreenID", sender: nil) {
                    self.performSegue(withIdentifier: "showMainScreenID", sender: nil)
                }
            }
        }
    }
}
