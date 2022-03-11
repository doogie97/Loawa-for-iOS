//
//  BookMarkViewController.swift
//  Loawa-for-iOS
//
//  Created by 최최성균 on 2022/03/08.
//

import UIKit

protocol BookMarkViewControllerDelegate: AnyObject {
    func searchName(name: String)
}

class BookMarkViewController: UIViewController {
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    weak var bookmarker: BookmarkStorage?
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
            self.showEditAlert(tag: sender.tag)
        })
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: {_ in
            UserDefaults.standard.removeObject(forKey: self.bookmarker?.userNames[sender.tag] ?? "")
            self.bookmarker?.userNames.remove(at: sender.tag)
            self.saveNames()
        })
        let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - functions
    private func showEditAlert(tag: Int) {
        let alert = UIAlertController(title: "북마크 이름 변경", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
            guard let nameToChange = alert.textFields?[0].text else { return }
            self.checkName(tag: tag, name: nameToChange)
            self.saveNames()
        })
        let noAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        alert.addTextField()
        self.present(alert, animated: true, completion: nil)
    }
    
    private func saveNames() {
        UserDefaults.standard.set(self.bookmarker?.userNames, forKey: "UserNames")
        self.bookmarkTableView.reloadData()
    }
    
    private func checkName(tag:Int, name: String) {
        do {
            try bookmarker?.checkName(name: name)
            UserDefaults.standard.set(UserDefaults.standard.url(forKey: self.bookmarker?.userNames[tag] ?? ""), forKey: name)
            UserDefaults.standard.removeObject(forKey: self.bookmarker?.userNames[tag] ?? "")
            self.bookmarker?.userNames[tag] = name
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

extension BookMarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarker?.userNames.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmarkTableViewCell = bookmarkTableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath)
        guard let bookmarkTableViewCell = bookmarkTableViewCell as? BookmarkTableViewCell else { return bookmarkTableViewCell }
        bookmarkTableViewCell.userNameLabel.text = self.bookmarker?.userNames[indexPath.row]
        bookmarkTableViewCell.editButton.tag = indexPath.row
        
        return bookmarkTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchName(name: self.bookmarker?.userNames[indexPath.row] ?? "")
        self.dismiss(animated: true, completion: nil)
    }
}
