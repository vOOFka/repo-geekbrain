//
//  VKWebViewController.swift
//  vkontakteVS
//
//  Created by Home on 27.08.2021.
//

import UIKit
import WebKit

class VKWebViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    //MARK: - Navigation
    @IBAction func logout (with segue: UIStoryboardSegue) {
        webView.cleanAllCookies()
        configurationWebView()
    }
    //MARK: Properties
    private let networkService = NetworkServiceImplimentation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationWebView()
    }
    
    fileprivate func configurationWebView() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7937212"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,groups,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByName('email').value = 'exit554@ya.ru';")
        webView.evaluateJavaScript("document.getElementsByName('pass').value = '123456';")
    }
    
    private func checkAuth() -> Bool {
        return (UserSession.shared.token != "") ? true : false
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
            return false
        }
    }
}

extension VKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        let token = params["access_token"]
        let userId = params["user_id"]
        UserSession.shared.token = token ?? ""
        UserSession.shared.userId = Int(userId ?? "123456") ?? 123456
        let checkWKAuth = shouldPerformSegue(withIdentifier: "showMainScreenID", sender: self)
        if checkWKAuth == true {
            performSegue(withIdentifier: "showMainScreenID", sender: self)
        }
        decisionHandler(.cancel)
    }
}

extension WKWebView {

    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }

    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}
