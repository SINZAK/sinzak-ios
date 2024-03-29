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
import RxDataSources
import PhotosUI

final class ChatVC: SZVC {
    // MARK: - Properties
    
    let mainView = ChatView()
    var viewModel: ChatVM
    let disposeBag = DisposeBag()

    // MARK: - Init
    
    init(viewModel: ChatVM) {
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
    
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.endTimer()
    }
   
    // MARK: - Helpers
    override func setNavigationBar() {
        super.setNavigationBar()
        let chatMenu = UIBarButtonItem(
            image: UIImage(named: "chatMenu"),
            style: .plain,
            target: nil,
            action: nil)
        navigationItem.rightBarButtonItem = chatMenu
    }
    override func configure() {
        mainView.collectionView.collectionViewLayout = configLayout()
        mainView.collectionView.register(MyChatBubbleCVC.self, forCellWithReuseIdentifier: String(describing: MyChatBubbleCVC.self))
        mainView.collectionView.register(OtherChatBubbleCVC.self, forCellWithReuseIdentifier: String(describing: OtherChatBubbleCVC.self))
        
        mainView.chatTextField.delegate = self
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
                        let value = owner.viewModel.messageSectionModels.value
                        let indexPaht = IndexPath(
                            item: (value.last?.items.count ?? 0) - 1,
                            section: value.count - 1
                        )
                        let cell = owner.mainView.collectionView.cellForItem(at: indexPaht)

                        let maxY = cell?.frame.maxY ?? 0
                        owner.mainView.setShowKeyboardLayout(
                            height: keyboardHeight,
                            maxY: maxY
                        )
                    } else {
                        owner.mainView.setHideKeyboardLayout()
                    }
                    owner.view.layoutIfNeeded()
                })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.showTripleAlertSheet(
                        firstActionText: "차단하기",
                        secondActionText: "신고하기",
                        thirdActionText: "채팅방 나가기",
                        firstCompletion: {
                            owner.showPopUpAlert(
                                message: "차단 시 서로의 게시글을 확인하거나 채팅을 할 수 없어요. 차단할까요?",
                                rightActionTitle: "차단하기",
                                rightActionCompletion: {
                                    let id = owner.viewModel.artDetailInfo.value.opponentUserId
                                    UserCommandManager.shared.report(userId: id, reason: "차단")
                                        .observe(on: MainScheduler.asyncInstance)
                                        .subscribe(
                                            onSuccess: { _ in
                                                owner.showSinglePopUpAlert(message: "차단 되었습니다.", actionCompletion: {
                                                    owner.navigationController?.popToRootViewController(animated: true)
                                                })
                                                owner.viewModel.leaveChatRoom()
                                                owner.mainView.setLeaveLayout()
                                            },
                                            onFailure: { error in
                                                owner.simpleErrorHandler.accept(error)
                                            })
                                        .disposed(by: owner.disposeBag)
                                }
                            )
                        },
                        secondCompletion: {
                            let id = owner.viewModel.artDetailInfo.value.opponentUserId
                            
                            let vc = ReportSelectVC(
                                userID: id,
                                userName: owner.viewModel.roomInfo?.roomName ?? ""
                            )
                            
                            owner.navigationController?.pushViewController(
                                vc,
                                animated: true
                            )
                        },
                        thirdCompletion: {
                            owner.showPopUpAlert(
                                message: "정말 채팅방을 나갈까요?",
                                rightActionTitle: "네, 나갈게요",
                                rightActionCompletion: {
                                    owner.viewModel.leaveChatRoom()
                                }
                            )
                        }
                    )
                })
            .disposed(by: disposeBag)

        mainView.albumButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.showPHPicker()
                })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.willDisplayCell
            .skip(1)
            .subscribe(with: self, onNext: { owner, event in
                if event.at == [0, 0] {
                    owner.viewModel.fetchPreviousMessage()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        viewModel.artDetailInfo
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                with: self,
                onNext: { owner, info in
                    owner.navigationItem.title = info.roomName
                    owner.mainView.setArtDetailInfo(info: info)
            })
            .disposed(by: disposeBag)
        
        let dataSource = getDataSource()
        let messageSectionModels = viewModel.messageSectionModels
            .asDriver()
        
        messageSectionModels
            .drive(mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(
            messageSectionModels.asObservable(),
            viewModel.indexPathToScroll.asObservable()
        )
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(with: self, onNext: { owner, zip in
            let indexPath = zip.1
            
            owner.mainView.collectionView.scrollToItem(
                at: indexPath,
                at: .bottom,
                animated: false
            )
            
            owner.viewModel.isPossibleFecthPreviousMessage = true
        })
        .disposed(by: disposeBag)
        
        viewModel.popView
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                })
            .disposed(by: disposeBag)
        
        viewModel.errorHandler
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, error in
                    owner.mainView.setLeaveLayout()
                    owner.simpleErrorHandler.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

private extension ChatVC {
    func getDataSource() -> RxCollectionViewSectionedReloadDataSource<MessageSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MessageSectionModel>(configureCell: { [weak self] _, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            
            if item.messageType == .leave {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LeaveCVC.identifier,
                    for: indexPath
                ) as! LeaveCVC
                
                cell.label.text = item.message
                self.mainView.setLeaveLayout()
                    
                return cell
            }
            
            if item.senderID == UserInfoManager.userID {
                switch item.messageType {
                case .text:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MyChatBubbleCVC.identifier,
                        for: indexPath
                    ) as! MyChatBubbleCVC
                    
                    cell.chatLabel.text = item.message
                    
                    return cell
                    
                case .image:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MyImageCVC.identifier,
                        for: indexPath
                    ) as! MyImageCVC
                
                    cell.setImage(url: item.message)
                        
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
                
            } else {
                
                switch item.messageType {
                case .text:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: OtherChatBubbleCVC.identifier,
                        for: indexPath
                    ) as! OtherChatBubbleCVC
                    
                    cell.chatLabel.text = item.message
                    
                    return cell
                    
                case .image:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: OtherImageCVC.identifier,
                        for: indexPath
                    ) as! OtherImageCVC
                
                    cell.setImage(url: item.message)
                        
                    return cell
                
                default:
                    return UICollectionViewCell()
                }
            }
        })
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

extension ChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let message = mainView.chatTextField.text ?? ""
        if message.isEmpty == true {
            return false
        }
        
        viewModel.sendTextMessage(message: message)
        mainView.chatTextField.text = ""
        return true
    }
     
}

private extension ChatVC {
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.view.tintColor = CustomColor.red
        picker.modalPresentationStyle = .fullScreen
        
        present(picker, animated: true)
    }
}

extension ChatVC: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        
        picker.dismiss(animated: true)
        if results.isEmpty { return }
        
        let itemProviders = results.map(\.itemProvider)
        
        Observable.combineLatest(itemProviders.map { getImage(with: $0) })
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(
                with: self,
                onNext: { owner, images in
                    owner.viewModel.uploadImage(images: images)
                }
            )
            .disposed(by: disposeBag)
        
        func getImage(with item: NSItemProvider) -> Observable<UIImage> {
            Log.debug("시작 - 1 - \(Thread.current)")
            return Observable<UIImage>.create { observer in
                Log.debug("시작 - 2 - \(Thread.current)")
                    if item.canLoadObject(ofClass: UIImage.self) {
                        item.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                            if let error = error {
                                Log.error(error)
                                return
                            }
                            guard let image = image as? UIImage else {
                                Log.error("이미지 타입 캐스팅 실패")
                                return }
                            observer.onNext(image)
                            Log.debug("끝 - 2 - \(Thread.current)")
                        })
                    } else {
                        Log.error("이미지 load 불가능 - \(Thread.current)")
                    }
                
                Log.debug("끝 - 1 - \(Thread.current)")
                return Disposables.create()
            }
        }
    }
}
