//
//  ViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/07.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var myActivityIndizator: UIActivityIndicatorView!
    
    var userNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.navigationDelegate = self
        loadWebPage("https://loawa.com/")
        if let namesKey = UserDefaults.standard.stringArray(forKey: "UserNames") {
            self.userNames = namesKey
        }
//        print(userNames)
    }
    //MARK: - IBAction
    
    @IBAction func touchGoBackButton(_ sender: UIBarButtonItem) {
        myWebView.goBack()
    }
    @IBAction func touchGoFowardButton(_ sender: UIBarButtonItem) {
        myWebView.goForward()
    }
    @IBAction func touchReloadButton(_ sender: UIBarButtonItem) {
        myWebView.reload()
    }
    @IBAction func testButton(_ sender: UIBarButtonItem) {
        print(UserDefaults.standard.dictionaryRepresentation())
//        guard let url = URL(string: "https://naver.com"),
//              UIApplication.shared.canOpenURL(url) else { return }
//
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func touchAddButton(_ sender: UIBarButtonItem) {
        showAlert()
    }
    @IBAction func touchBookMarkButton(_ sender: UIBarButtonItem) {
        guard let bookMarkVC = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkViewController") else { return }
        bookMarkVC.modalPresentationStyle = .fullScreen
        self.present(bookMarkVC, animated: true, completion: nil)
    }
    
    //MARK: - functions
    
    private func loadWebPage(_ url: String) {
        guard let myURL = URL(string: url) else { return }
        let myRequst = URLRequest(url: myURL)
        myWebView.load(myRequst)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "등록", message: "유저 별명을 입력해 주세요.", preferredStyle: .alert)
        alert.addTextField()
        let yesAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            guard let key = alert.textFields?[0].text?.trimmingCharacters(in: .whitespaces) else { return }
            guard self.checkName(name: key) else { return }
            self.addBookMark(key: key)
//            for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//                print("\(key) & \(value)")
//            }
        })
        let noAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addBookMark(key: String) {
        guard let currentURL = myWebView.url else { return }
        self.userNames.append(key)
        UserDefaults.standard.set(self.userNames, forKey: "UserNames")
        UserDefaults.standard.set(currentURL, forKey: key)
    }
    
    private func checkName(name: String) -> Bool {
        if name.trimmingCharacters(in: .whitespaces).count == 0 {
            let alert = UIAlertController(title: "경고", message: "공백은 안댕!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}

extension ViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.myActivityIndizator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.myActivityIndizator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.myActivityIndizator.stopAnimating()
    }
}
