//
//  BookMarkViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//

import UIKit

protocol BookMarkViewControllerDelegate: AnyObject {
    func sendName(name: String)
}

class BookMarkViewController: UIViewController {
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    let editNotiName = Notification.Name("editName")
    var userNames : [String] = []
    weak var delegate: BookMarkViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
    }
    //MARK: - IBActions
    @IBAction func touchCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchMoreEditButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "이름 수정", style: .default, handler: {_ in
            self.editAlert(tag: sender.tag)
        })
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
            UserDefaults.standard.removeObject(forKey: self.userNames[sender.tag])
            self.userNames.remove(at: sender.tag)
            UserDefaults.standard.set(self.userNames, forKey: "UserNames")
            self.bookmarkTableView.reloadData()
        })
        let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editAlert(tag: Int) {
        let alert = UIAlertController(title: "북마크 이름 변경", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            guard let nameToChange = alert.textFields?[0].text else { return }
            self.userNames[tag] = nameToChange
            self.bookmarkTableView.reloadData()
        })
        alert.addAction(yesAction)
        alert.addTextField()
        self.present(alert, animated: true, completion: nil)
    }
}

extension BookMarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmarkTableViewCell = bookmarkTableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath)
        guard let bookmarkTableViewCell = bookmarkTableViewCell as? BookmarkTableViewCell else { return bookmarkTableViewCell }
        bookmarkTableViewCell.userNameLabel.text = self.userNames[indexPath.row]
        bookmarkTableViewCell.editButton.tag = indexPath.row
        
        return bookmarkTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendName(name: self.userNames[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
