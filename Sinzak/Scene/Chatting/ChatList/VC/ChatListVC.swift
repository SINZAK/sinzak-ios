//
//  ChatListVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ChatListVC: SZVC {
    // MARK: - Properties
    let mainView = ChatListView()
    let viewModel: ChatListVM
    let disposeBag = DisposeBag()
    // MARK: - Init
    
    init(viewModel: ChatListVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        StompManager.shared.disconnect()
        viewModel.fetchChatList()
    }
    // MARK: - Helper
    override func setNavigationBar() {
        let leftTitle = UIBarButtonItem(
            title: "채팅",
            style: .plain,
            target: nil,
            action: nil
        )
        leftTitle.setTitleTextAttributes(
            [
                .font: UIFont.subtitle_B,
                .foregroundColor: CustomColor.label
            ],
            for: .disabled
        )
        leftTitle.isEnabled = false
        navigationItem.leftBarButtonItem = leftTitle
    }
    override func configure() {
        mainView.collectionView.register(ChatListCVC.self, forCellWithReuseIdentifier: String(describing: ChatListCVC.self))
        mainView.collectionView.collectionViewLayout = createLayout()
        bind()
    }
}

// MARK: - Bind

extension ChatListVC {
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.collectionView.rx.modelSelected(ChatRoom.self)
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, chatRoom in
                    let vm = DefaultChatVM(roomID: chatRoom.roomUUID)
                    let vc = ChatVC(viewModel: vm)
                    owner.navigationController?.pushViewController(vc, animated: true)
                })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        let chatRoomsDataSource = getChatRoomsDataSource()
        let chatRoomSectionModel = viewModel.chatRoomSectionModel
            .asDriver()
        
        chatRoomSectionModel
            .skip(1)
            .map { !$0[0].items.isEmpty }
            .drive(mainView.noContentsLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        chatRoomSectionModel
            .drive(mainView.collectionView.rx.items(dataSource: chatRoomsDataSource))
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Data Source

extension ChatListVC {
    func getChatRoomsDataSource() -> RxCollectionViewSectionedReloadDataSource<ChatRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<ChatRoomSectionModel>(configureCell: { _, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ChatListCVC.identifier,
                for: indexPath
            ) as! ChatListCVC
            
            cell.setCellInfo(chatRoom: item)
            return cell
        })}
}

// 컴포지셔널 레이아웃
extension ChatListVC {
    /// 컴포지셔널 레이아웃 세팅
    /// - 테이블뷰와 비슷한 형태이므로 list configuration 적용
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.separatorConfiguration.color = .clear
        config.backgroundColor = CustomColor.background
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
