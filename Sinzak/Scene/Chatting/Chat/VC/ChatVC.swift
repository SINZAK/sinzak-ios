//
//  ChatVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class ChatVC: SZVC {
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    let mainView = ChatView()
    let dummyChat: [[String]] = [
        [
            "안녕하세요",
            "판매중 맞으실까요?",
            "앗, 안녕하세요!",
            "넵 판매중 맞습니다 :)",
            "직거래 괜찮으신가요?",
            "직거래하기 너무 클까요?",
            "네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
        ],
        [
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ",
            "딱 그 크기인 캔버스 입니다ㅎㅎ네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면",
            "네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면네~ 사이즈 써 놓으신 거 보시면",
            "딱 그 크기인 캔버",
            "딱 그 크기인 캔",
            "딱 그 크기인g",
            "네~ 사이즈",
            "크기인",
            "딱",
            "딱그",
        ]
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
   
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "김신작" // 채팅 상대방 이름
        let chatMenu = UIBarButtonItem(
            image: UIImage(named: "chatMenu"),
            style: .plain,
            target: nil,
            action: nil)
        navigationItem.rightBarButtonItem = chatMenu
    }
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.collectionViewLayout = configLayout()
        mainView.collectionView.register(MyChatBubbleCVC.self, forCellWithReuseIdentifier: String(describing: MyChatBubbleCVC.self))
        mainView.collectionView.register(OtherChatBubbleCVC.self, forCellWithReuseIdentifier: String(describing: OtherChatBubbleCVC.self))
        
        bind()
    }
}

// MARK: - Bind
private extension ChatVC {
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        let tapViewGesture = UITapGestureRecognizer(target: nil, action: nil)
        view.addGestureRecognizer(tapViewGesture)
        tapViewGesture.rx.event
            .asSignal(onErrorRecover: { _ in return .never() })
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(
                with: self,
                onNext: { owner, keyboardHeight in
                    if keyboardHeight > 0 {
                        owner.mainView.setShowKeyboardLayout(height: keyboardHeight)
                    } else {
                        owner.mainView.setHideKeyboardLayout()
                    }
                    owner.view.layoutIfNeeded()
                })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                
                    owner.showDoubleAlertSheet(
                        firstActionText: "신고하기",
                        secondActionText: "채팅방 나가기"
                    )
                })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
    
    }
}

// 콜렉션 뷰 설정
extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dummyChat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyChat[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item % 3 == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyChatBubbleCVC.self), for: indexPath) as? MyChatBubbleCVC else { return UICollectionViewCell() }
            cell.chatLabel.text = dummyChat[indexPath.section][indexPath.item]
            cell.dateLabel.text = "오전 10:02"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OtherChatBubbleCVC.self), for: indexPath) as? OtherChatBubbleCVC else { return UICollectionViewCell() }
            cell.chatLabel.text = dummyChat[indexPath.section][indexPath.item]
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
        config.backgroundColor = CustomColor.background
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.separatorConfiguration.color = .clear
            configuration.backgroundColor = CustomColor.background
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 6.0,
                trailing: 0
            )
                        
            return section
        }
    }
}
