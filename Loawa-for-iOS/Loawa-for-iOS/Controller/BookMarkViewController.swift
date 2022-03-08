//
//  BookMarkViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//

import UIKit

class BookMarkViewController: UIViewController {
    @IBOutlet weak var bookmarkTableView: UITableView!
    let cellName = "BookmarkTableViewCell"
    var userNames : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
    }
    //MARK: - IBActions
    @IBAction func touchCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BookMarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let bookmarkTableViewCell = bookmarkTableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as? BookmarkTableViewCell else { return }
        let bookmarkTableViewCell = bookmarkTableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath)
        guard let bookmarkTableViewCell = bookmarkTableViewCell as? BookmarkTableViewCell else { return bookmarkTableViewCell }
        bookmarkTableViewCell.userNameLabel.text = self.userNames[indexPath.row]
        
        return bookmarkTableViewCell
    }
}
