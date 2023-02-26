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
        
    }
    /// 글 수정
    @objc func editPost() {
        
    }
    /// 글 삭제
    @objc func removePost() {
        
    }
    /// 글 작성자 신고하기
    @objc func reportUser() {
        
    }
    /// 글 작성자 차단하기
    @objc func blockUser() {
        
    }
    // MARK: - Helpers
    override func configure() {
        
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        let menu = UIBarButtonItem(image: UIImage(named: "chatMenu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItem = menu
    }
}
