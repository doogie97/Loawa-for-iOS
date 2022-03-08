//
//  BookMarkViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//

import UIKit

class BookMarkViewController: UIViewController {
    var userNames : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func touchCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
