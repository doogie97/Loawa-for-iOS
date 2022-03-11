//
//  ViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/07.
//

import UIKit
import WebKit

final class ViewController: UIViewController {
    let bookmarkstorage = BookmarkStorage()
    
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var myActivityIndizator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let namesKey = UserDefaults.standard.stringArray(forKey: "UserNames") {
            bookmarkstorage.userNames = namesKey
        }
        myWebView.navigationDelegate = self
        loadWebPage("https://loawa.com/")
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
        let alert = UIAlertController(title: "북마크 등록", message: "유저 별명을 입력해 주세요.", preferredStyle: .alert)
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
    @IBAction func touchBookMarkButton(_ sender: UIBarButtonItem) {
        guard !bookmarkstorage.userNames.isEmpty else { showBasicAlert(title:"경고" ,message: "등록된 즐겨찾기가 없습니다."); return }
        guard let bookMarkVC = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkViewController") as? BookMarkViewController else { return }
        bookMarkVC.delegate = self
        bookMarkVC.bookmarker = self.bookmarkstorage

        self.present(bookMarkVC, animated: true, completion: nil)
    }
    @IBAction func touchShareButton(_ sender: UIBarButtonItem) {
        var objectsToShare = [URL]()
        guard let url = myWebView.url else { return }
        objectsToShare.append(url)
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    //MARK: - functions
    private func loadWebPage(_ url: String) {
        guard let myURL = URL(string: url) else { return }
        let myRequst = URLRequest(url: myURL)
        myWebView.load(myRequst)
    }
    
    private func checkName(key: String) {
        do {
            try bookmarkstorage.checkName(name: key)
            self.bookmarkstorage.addBookMark(webView: self.myWebView, key: key)
            self.showBasicAlert(title: nil, message: "등록완료!")
        } catch let error as RegisterError {
            switch error {
            case .emptyTextField:
                showBasicAlert(title:"경고" ,message: error.errorMessage)
            case .duplicatenames:
                showBasicAlert(title:"경고" ,message: error.errorMessage)
            }
        } catch { showBasicAlert(title: nil, message: "알 수 없는 오류")}
    }
    
    private func showBasicAlert(title: String?, message: String) {
        self.present(bookmarkstorage.setBasicAlert(title: title, message: message), animated: true, completion: nil)
    }
}
extension ViewController: BookMarkViewControllerDelegate {
    func searchName(name: String) {
        guard let userURL = UserDefaults.standard.url(forKey: name) else { return }
        loadWebPage("\(userURL)")
    }
}
extension ViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.myActivityIndizator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.myActivityIndizator.stopAnimating()
        myWebView.allowsBackForwardNavigationGestures = true
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.myActivityIndizator.stopAnimating()
    }
}
