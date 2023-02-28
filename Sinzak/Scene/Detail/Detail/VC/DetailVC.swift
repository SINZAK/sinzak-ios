//
//  DetailVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/26.
//

import UIKit

enum DetailOwner {
    case mine
    case other
    var menus: [String] {
        switch self {
        case .mine:
            return ["수정하기", "삭제하기"]
        case .other:
            return ["신고하기", "님 차단하기"]
        }
    }
}
enum DetailType {
    case purchase
    case request
    var isSizeShown: Bool {
        switch self {
        case .purchase:
            return true
        case .request:
            return false
        }
    }
}
final class DetailVC: SZVC {
    // MARK: - Properties
    private let mainView = DetailView()
    var owner: DetailOwner?
    var type: DetailType?
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Actions
    @objc func menuButtonTapped(_ sender: UIBarButtonItem) {
        // ActionSheet 띄우기
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let writerName = "신작" // 글작성자 이름
        owner = DetailOwner.other
        guard let owner = owner else { return }
        switch owner {
        case .mine:
            let edit = UIAlertAction(title: I18NStrings.edit, style: .default) { [weak self] _ in
                self?.editPost()
            }
            let remove = UIAlertAction(title: I18NStrings.remove, style: .default) { [weak self] _ in
                self?.removePost()
            }
            alert.addAction(edit)
            alert.addAction(remove)
        case .other:
            let report = UIAlertAction(title: I18NStrings.report, style: .default) { [weak self] _ in
                self?.reportUser()
            }
            let block = UIAlertAction(title: writerName + I18NStrings.blockUser, style: .default) { [weak self] _ in
                self?.blockUser()
            }
            alert.addAction(report)
            alert.addAction(block)
        }
        let cancel = UIAlertAction(title: I18NStrings.cancel, style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    /// 글 수정
    func editPost() {
        print("글 수정")
    }
    /// 글 삭제
    func removePost() {
        print("글 삭제")
    }
    /// 글 작성자 신고하기
    func reportUser() {
        print("신고")
    }
    /// 글 작성자 차단하기
    func blockUser() {
        print("차단")
    }
    /// 가격 제안하기
    @objc func priceOfferButtonTapped(_ sender: UIButton) {
        let vc = SendPriceOfferVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.priceOfferButton.addTarget(self, action: #selector(priceOfferButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        let menu = UIBarButtonItem(image: UIImage(named: "chatMenu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = menu
    }
}
