//
//  WritePostVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard

final class WritePostVC: SZVC {
    // MARK: - Properties
    private let mainView: WritePostView
    private let category: WriteCategory
    private let disposeBag = DisposeBag()
    private let viewModel: WritePostVM
    private var keyboardHeight: CGFloat = 0.0
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    init(viewModel: WritePostVM, category: WriteCategory) {
        self.viewModel = viewModel
        self.mainView = WritePostView(category: category)
        self.category = category
        
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
    // MARK: - Actions
    @objc func nextButtonTapped(_ sender: UIButton) {
        let vc = ArtworkInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        switch category {
        case .sellingArtwork:
            navigationItem.title = "작품 정보"
        case .request:
            navigationItem.title = "의뢰 정보"
        case .work:
            navigationItem.title = "작업해요"
        }
        
        let completeBarButton = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: nil,
            action: nil
        )
        completeBarButton.setTitleTextAttributes(
            [
                .foregroundColor: CustomColor.alertTint2,
                .font: UIFont.body_M
            ],
            for: .normal
        )
        
        navigationItem.rightBarButtonItem = completeBarButton
    }
}

// MARK: - Bind

private extension WritePostVC {
    
    func bind() {
        
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        mainView.collectionView.rx.itemSelected
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, indexPath in
                    switch indexPath {
                    case [0, 0]:
                        let count = owner.viewModel.photoSections.value[0].items.count
                        guard count != 6 else { return }
                        
                        var config = PHPickerConfiguration(photoLibrary: .shared())
                        config.selectionLimit = 6 - count
                        config.selection = .ordered
                        config.filter = .images
                        
                        let vc = PHPickerViewController(configuration: config)
                        vc.view.tintColor = CustomColor.red
                        vc.delegate = owner
                        vc.modalPresentationStyle = .fullScreen
                        
                        owner.present(vc, animated: true)
                    default:
                        break
                    }
            })
            .disposed(by: disposeBag)
        
        mainView.showTermsButton.rx.tap
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    let vc = WebVC()
                    vc.destinationURL = "https://sinzak.notion.site/bfd66407b0ca4d428a8214165627c191"
                    owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        /*
        let startDragGesture = UILongPressGestureRecognizer(target: nil, action: nil)
        mainView.collectionView.addGestureRecognizer(startDragGesture)
        startDragGesture.rx.event
            .bind(
                with: self,
                onNext: { owner, gesture in
                    
                    let locatioin = gesture.location(in: owner.mainView)
                    
                    let cell = owner.mainView.collectionView.cellForItem(at: [0, 1]) as! SelectedPhotoCVC
                    let offset = cell.frame.maxX
                    
                    Log.debug(offset)
                    
                    if locatioin.x < 16 + 72 + 8 { return }
                    
                    guard owner.mainView.collectionView.frame.contains(locatioin) else {
                        
                        owner
                            .mainView
                            .collectionView
                            .endInteractiveMovement()
                        return
                    }
                    
                    guard let indexPath = owner
                        .mainView
                        .collectionView
                        .indexPathForItem(at: gesture.location(in: owner.mainView.collectionView)) else { return }
                    
                    
                    switch gesture.state {
                    case .began:
                        owner.mainView.collectionView.beginInteractiveMovementForItem(at: indexPath)
                        
                    case .changed:
                        if indexPath == [0, 0] { return }
                        owner
                            .mainView
                            .collectionView
                            .updateInteractiveMovementTargetPosition(
                                gesture.location(in: owner.mainView.collectionView)
                            )
                    case .ended:
                        owner
                            .mainView
                            .collectionView
                            .endInteractiveMovement()

                        
                    default:
                        owner.mainView.collectionView.cancelInteractiveMovement()
                    }
                })
            .disposed(by: disposeBag)
         */
        
        let titleTextViewText = mainView.titleTextView.rx.text
            .share()
        
        titleTextViewText
            .map { !($0 ?? "").isEmpty }
            .bind(to: mainView.titlePlaceholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        mainView.isPossibleSuggestButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.mainView.isPossibleSuggestButton.isSelected.toggle()
                })
            .disposed(by: disposeBag)
            
        let bodyTextViewText = mainView.bodyTextView.rx.text
            .orEmpty
            .share()
        
        bodyTextViewText
            .map { !$0.isEmpty }
            .bind(to: mainView.bodyPlaceholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(
                with: self,
                onNext: { owner, keyboardVisibleHeight in
                    owner.keyboardHeight = keyboardVisibleHeight
                    if keyboardVisibleHeight > 0 {
                        owner.mainView.remakeKeyboardShowLayout()
                        let tapGestureRecognizer = UITapGestureRecognizer(target: owner, action: #selector(owner.endEditing))
                        owner.mainView.contentView.addGestureRecognizer(tapGestureRecognizer)
                        tapGestureRecognizer.delegate = self
                        self.tapGestureRecognizer = tapGestureRecognizer
                    } else {
                        owner.mainView.remakeKeyboardNotShowLayout()
                        guard let tapGestureRecognizer = owner.tapGestureRecognizer else { return }
                        owner.mainView.contentView.removeGestureRecognizer(tapGestureRecognizer)
                    }
                    
                })
            .disposed(by: disposeBag)
        
        let titleTextViewEditBegin = mainView.titleTextView.rx.didBeginEditing
        let titleTextViewBounds = mainView.titleTextView.rx.observe(CGRect.self, #keyPath(UIView.bounds))
        
        Observable.combineLatest(titleTextViewEditBegin, titleTextViewBounds)
            .bind(with: self, onNext: { owner, tuple in
                
                let bounds = tuple.1 ?? .zero
                
                let titleTextViewMinY = owner.mainView.titleTextView.frame.minY
                let titleTextViewHeight = bounds.height
                let titleTextViewMaxY = titleTextViewHeight + titleTextViewMinY
                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                let navigationBarHeight = owner.navigationController?.navigationBar.frame.size.height ?? 0.0
                
                let textViewBottomToMaxY = owner.view.frame.height - statusBarHeight - navigationBarHeight - (titleTextViewMaxY - owner.mainView.scrollView.contentOffset.y)
                
                if owner.keyboardHeight > textViewBottomToMaxY {
                    owner.mainView.scrollView.contentOffset = CGPoint(x: 0, y: owner.mainView.scrollView.contentOffset.y + (owner.keyboardHeight - textViewBottomToMaxY))
                }
            })
            .disposed(by: disposeBag)
        
        let bodyTextViewEditBegin = mainView.bodyTextView.rx.didBeginEditing
        let bodyTextViewBounds = mainView.bodyTextView.rx.observe(CGRect.self, #keyPath(UIView.bounds))
        
        Observable.combineLatest(bodyTextViewEditBegin, bodyTextViewBounds)
            .bind(with: self, onNext: { owner, tuple in
                
                let bounds = tuple.1 ?? .zero
                
                let bodyTextViewMinY = owner.mainView.bodyTextView.frame.minY
                let bodyTextViewHeight = bounds.height
                let bodyTextViewMaxY = bodyTextViewHeight + bodyTextViewMinY
                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                let navigationBarHeight = owner.navigationController?.navigationBar.frame.size.height ?? 0.0
                
                let bodyViewBottomToMaxY = owner.view.frame.height - statusBarHeight - navigationBarHeight - (bodyTextViewMaxY - owner.mainView.scrollView.contentOffset.y)
                
                if owner.keyboardHeight > bodyViewBottomToMaxY {
                    owner.mainView.scrollView.contentOffset = CGPoint(x: 0, y: owner.mainView.scrollView.contentOffset.y + (owner.keyboardHeight - bodyViewBottomToMaxY))
                }
            })
            .disposed(by: disposeBag)
        
        mainView.widthSizeInputTextFieldView.inputTextField.rx.controlEvent(.editingDidBegin)
            .bind(with: self, onNext: { owner, _ in
                owner.mainView.scrollView.scroll(to: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.verticalSizeInputTextFieldView.inputTextField.rx.controlEvent(.editingDidBegin)
            .bind(with: self, onNext: { owner, _ in
                owner.mainView.scrollView.scroll(to: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.heightSizeInputTextFieldView.inputTextField.rx.controlEvent(.editingDidBegin)
            .bind(with: self, onNext: { owner, _ in
                owner.mainView.scrollView.scroll(to: .bottom, animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    
                    if  owner.viewModel.photoSections.value[0].items.count > 1 ||
                        !owner.mainView.titleTextView.text.isEmpty ||
                        !(owner.mainView.priceTextField.text ?? "").isEmpty ||
                        !owner.mainView.bodyTextView.text.isEmpty ||
                        !(owner.mainView.widthSizeInputTextFieldView.inputTextField.text ?? "").isEmpty ||
                        !(owner.mainView.verticalSizeInputTextFieldView.inputTextField.text ?? "").isEmpty ||
                        !(owner.mainView.heightSizeInputTextFieldView.inputTextField.text ?? "").isEmpty {
                        
                        owner.showPopUpAlert(
                            message: "작성 중인 내용이 있습니다.\n글쓰기를 취소할까요?",
                            rightActionTitle: "글쓰기 취소",
                            rightActionCompletion: {
                                owner.navigationController?.popViewController(animated: true)
                            }
                        )
                        return
                        
                    } else {
                        
                        owner.navigationController?.popViewController(animated: true)
                        return
                    }
                    
            })
            .disposed(by: disposeBag)
         
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    
                    if (owner.viewModel.photoSections.value[0].items.count == 1) ||
                        owner.mainView.titleTextView.text.isEmpty ||
                        (owner.mainView.priceTextField.text ?? "").isEmpty ||
                        owner.mainView.bodyTextView.text.isEmpty {
                        
                        owner.showSinglePopUpAlert(message: "사진, 제목, 가격, 내용은\n필수 입력 항목이에요.")
                        return
                    }
                    
                    switch owner.category {
                    case .sellingArtwork:
                        
                        owner.viewModel.postProductsComplete(
                            title: owner.mainView.titleTextView.text,
                            price: Int(owner.mainView.priceTextField.text ?? "-1") ?? -1,
                            suggest: owner.mainView.isPossibleSuggestButton.isSelected,
                            body: owner.mainView.bodyTextView.text,
                            width: Int(owner.mainView.widthSizeInputTextFieldView.inputTextField.text ?? "0") ?? 0,
                            vertical: Int(owner.mainView.verticalSizeInputTextFieldView.inputTextField.text ?? "0") ?? 0,
                            heigth: Int(owner.mainView.heightSizeInputTextFieldView.inputTextField.text ?? "0") ?? 0
                        )
                        
                    case .work, .request:
                        
                        owner.viewModel.postWorksComplete(
                            title: owner.mainView.titleTextView.text,
                            price: Int(owner.mainView.priceTextField.text ?? "-1") ?? -1,
                            suggest: owner.mainView.isPossibleSuggestButton.isSelected,
                            body: owner.mainView.bodyTextView.text
                        )
                        
                    }
                })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        let dataSource = getDataSourece()
        
        /*
        dataSource.canMoveItemAtIndexPath = { _, indexPath in
            switch indexPath {
            case [0, 0]:    return false
            default:        return true
            }
        }
        
        dataSource.moveItem = { [weak self] _, source, destination in
            guard let self = self else { return }
            
            var currentPhotos = self.viewModel.photoSections.value[0].items
            let image = currentPhotos.remove(at: source.item)
            currentPhotos.insert(image, at: destination.item)
            
            let section = PhotoSection(model: "", items: currentPhotos)
            self.viewModel.photoSections.accept([section])
            
            for i in 0..<currentPhotos.count {
                guard let cell = self.mainView.collectionView.cellForItem(at: [0, i]) as? SelectedPhotoCVC else { continue }
                
                if i == 1 {
                    cell.configThumbnailCell()
                } else {
                    cell.configNotThumbnailCell()
                }
            }
        }
         */
        
        viewModel.photoSections
            .asDriver()
            .drive(mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.needDismiss
            .asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Pricate Method

private extension WritePostVC {
    
    @objc
    func endEditing() {
        view.endEditing(true)
    }
}

extension WritePostVC: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider)
        
        Observable.combineLatest(itemProviders.map { getImage(with: $0) })
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(
                with: self,
                onNext: { owner, images in
                    owner.viewModel.photoSelected(images: images)
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

private extension WritePostVC {
    
    func getDataSourece() -> RxCollectionViewSectionedReloadDataSource<PhotoSection> {
        return RxCollectionViewSectionedReloadDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                
                switch indexPath {
                case [0, 0]:
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SelectPhotoCVC.identifier,
                        for: indexPath
                    ) as? SelectPhotoCVC else { return UICollectionViewCell() }
                    
                    let count = self.viewModel.photoSections.value[0].items.count - 1
                    cell.configCountLabel(count: count)
                    
                    return cell
                default:
                    
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SelectedPhotoCVC.identifier,
                        for: indexPath
                    ) as? SelectedPhotoCVC else { return UICollectionViewCell() }
                    cell.configCellImage(with: item)
                    if indexPath.item == 1 { cell.configThumbnailCell() }
                    cell.deleteImage = self.viewModel.deleteImage
                    
                    return cell
                }
            })
    }
}

// MARK: - Touch Gesture

extension WritePostVC {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        
        var point = touch.location(in: mainView.contentView)
        point = CGPoint(x: point.x, y: point.y * 1.25)

        if mainView.collectionView.frame.contains(point) {
            return false
        } else {
            return true
        }
    }
}
