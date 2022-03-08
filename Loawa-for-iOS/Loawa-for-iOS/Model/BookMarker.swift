//
//  BookMark.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//

import UIKit
import WebKit

final class BookMarker {
    var userNames: [String] = []
    
    func addBookMark(webView: WKWebView ,key: String) {
        guard let currentURL = webView.url else { return }
        userNames.append(key)
        UserDefaults.standard.set(self.userNames, forKey: "UserNames")
        UserDefaults.standard.set(currentURL, forKey: key)
    }
    func checkName(name: String) throws {
        if name.trimmingCharacters(in: .whitespaces).count == 0 {
            throw RegisterError.emptyTextField
        } else if self.userNames.contains(name) {
            throw RegisterError.duplicatenames
        }
    }
}
