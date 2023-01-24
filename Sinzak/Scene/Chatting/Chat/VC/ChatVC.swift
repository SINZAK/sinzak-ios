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
    let dummyChat: [String] = [
        "안녕하세요",
        "판매중 맞으실까요?",
        "앗, 안녕하세요!",
        "넵 판매중 맞습니다 :)",
        "직거래 괜찮으신가요?",
        "직거래하기 너무 클까요?",
        "네~ 사이즈 써 놓으신 거 보시면",
        "딱 그 크기인 캔버스 입니다ㅎㅎ"
    ]
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
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.collectionViewLayout = createLayout()
        mainView.collectionView.register(MyChatBubbleCVC.self, forCellWithReuseIdentifier: String(describing: MyChatBubbleCVC.self))
        mainView.collectionView.register(OtherChatBubbleCVC.self, forCellWithReuseIdentifier: String(describing: OtherChatBubbleCVC.self))
    }
}
// 콜렉션 뷰 설정
extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyChat.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item % 3 == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OtherChatBubbleCVC.self), for: indexPath) as? OtherChatBubbleCVC else { return UICollectionViewCell() }
            cell.chatLabel.text = dummyChat[indexPath.item]
            cell.dateLabel.text = "오전 10:02"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyChatBubbleCVC.self), for: indexPath) as? MyChatBubbleCVC else { return UICollectionViewCell() }
            cell.chatLabel.text = dummyChat[indexPath.item]
            cell.dateLabel.text = "오전 10:02"
            return cell
        }
    }
}
// 컴포지셔널 레이아웃
extension ChatVC {
    /// 컴포지셔널 레이아웃 세팅
    /// - 테이블뷰와 비슷한 형태이므로 list configuration 적용
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.separatorConfiguration.color = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
