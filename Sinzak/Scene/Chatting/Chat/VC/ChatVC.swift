//
//  ChatVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit

final class ChatVC: SZVC {
    // MARK: - Properties
    let mainView = ChatView()
    // MARK: - Init
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
    @objc func chatMenuButtonTapped(_ sender: UIBarButtonItem) {
        // 액션시트 설정
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let finished = UIAlertAction(title: "거래완료", style: .default) { action in
            // 거래완료 액션
        }
        let isDealing = UIAlertAction(title: "거래중", style: .default) { action in
            // 거래중 액션
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(finished)
        alert.addAction(isDealing)
        alert.addAction(cancel)
        // 액션시트 색상
        alert.view.tintColor = CustomColor.black
        // 액션시트 띄우기
        present(alert, animated: true)
    }
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "김신작" // 채팅 상대방 이름
        let chatMenu = UIBarButtonItem(
            image: UIImage(named: "chatMenu"),
            style: .plain,
            target: self,
            action: #selector(chatMenuButtonTapped))
        navigationItem.rightBarButtonItem = chatMenu
    }
    override func configure() {
    }
}
