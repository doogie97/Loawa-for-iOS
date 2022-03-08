//
//  ViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/07.
//

import UIKit
import WebKit

final class ViewController: UIViewController {
    let bookMarker = BookMarker()
    
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var myActivityIndizator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.navigationDelegate = self
        loadWebPage("https://loawa.com/")
        if let namesKey = UserDefaults.standard.stringArray(forKey: "UserNames") {
            bookMarker.userNames = namesKey
        }
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
    @IBAction func touchAddButton(_ sender: UIBarButtonItem) {
        showAddAlert()
    }
    @IBAction func touchBookMarkButton(_ sender: UIBarButtonItem) {
        guard !bookMarker.userNames.isEmpty else { basicAlert(title:"경고" ,message: "등록된 즐겨찾기가 없습니다."); return }
        guard let bookMarkVC = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkViewController") as? BookMarkViewController else { return }
        bookMarkVC.userNames = bookMarker.userNames
        bookMarkVC.modalPresentationStyle = .fullScreen
        self.present(bookMarkVC, animated: true, completion: nil)
    }
    //MARK: - functions
    private func loadWebPage(_ url: String) {
        guard let myURL = URL(string: url) else { return }
        let myRequst = URLRequest(url: myURL)
        myWebView.load(myRequst)
    }
    
    private func showAddAlert() {
        let alert = UIAlertController(title: "등록", message: "유저 별명을 입력해 주세요.", preferredStyle: .alert)
        alert.addTextField()
        let yesAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            guard let key = alert.textFields?[0].text else { return }
            self.checkName(key: key)
        })
        let noAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func checkName(key: String) {
        do {
            try bookMarker.checkName(name: key)
            self.bookMarker.addBookMark(webView: self.myWebView, key: key)
            self.basicAlert(title: nil, message: "등록완료!")
        } catch let error as RegisterError {
            switch error {
            case .emptyTextField:
                basicAlert(title:"경고" ,message: "공백 ㄴㄴ")
            case .duplicatenames:
                basicAlert(title:"경고" ,message: "중복 ㄴㄴ")
            }
        } catch { basicAlert(title: nil, message: "알 수 없는 오류")}
    }
    
    private func basicAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
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
