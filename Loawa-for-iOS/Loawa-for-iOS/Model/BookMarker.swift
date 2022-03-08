//
//  BookMark.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//

import UIKit
import WebKit

class BookMarker {
    var userNames: [String] = []
    
    func addBookMark(webView: WKWebView ,key: String) { // 북마커로
        guard let currentURL = webView.url else { return }
        userNames.append(key)
        UserDefaults.standard.set(self.userNames, forKey: "UserNames")
        UserDefaults.standard.set(currentURL, forKey: key)
    }
}
