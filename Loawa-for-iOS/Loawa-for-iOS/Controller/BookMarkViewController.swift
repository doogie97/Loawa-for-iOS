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
    @IBOutlet weak var editButton: UIBarButtonItem!
    
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
    @IBAction func touchEditButton(_ sender: UIBarButtonItem) {
        if self.bookmarkTableView.isEditing {
            self.editButton.title = "수정"
            self.bookmarkTableView.setEditing(false, animated: true)
        } else {
            self.editButton.title = "완료"
            self.bookmarkTableView.setEditing(true, animated: true)
        }
    }
    @IBAction func touchMoreEditButton(_ sender: UIButton) {
        self.userNames[0] = "안녕!"
        self.bookmarkTableView.reloadData()
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
//        bookmarkTableViewCell.editButton.tag = indexPath.row
        
        return bookmarkTableViewCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserDefaults.standard.removeObject(forKey: self.userNames[indexPath.row])
            self.userNames.remove(at: indexPath.row)
            UserDefaults.standard.set(self.userNames, forKey: "UserNames")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendName(name: self.userNames[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
