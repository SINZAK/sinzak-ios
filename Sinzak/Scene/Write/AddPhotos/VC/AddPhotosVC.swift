//
//  AddPhotosVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxDataSources

final class AddPhotosVC: SZVC {
    // MARK: - Properties
    private let mainView = AddPhotosView()
    private let disposeBag = DisposeBag()
    private let viewModel: AddPhotosVM
    
    init(viewModel: AddPhotosVM) {
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
    // MARK: - Actions
    @objc func nextButtonTapped(_ sender: UIButton) {
        let vc = ArtworkInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.addPhotos
    }
}

private extension AddPhotosVC {
    
    func bind() {
        
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        mainView.uploadPhotoButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                var config = PHPickerConfiguration(photoLibrary: .shared())
                config.selectionLimit = 5
                config.selection = .ordered
                config.filter = .images
                
                let vc = PHPickerViewController(configuration: config)
                vc.view.tintColor = CustomColor.red
                vc.delegate = self
                vc.modalPresentationStyle = .fullScreen
                
                owner.present(vc, animated: true)
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindOutput() {
        
        let dataSource = getDataSourece()
        viewModel.photoSections
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.photoSections
            .map { sections in
                guard !sections.isEmpty else {
                    return "0"
                }
                
                let count = sections[0].items.count
                return "\(count)"
            }
            .asDriver(onErrorJustReturn: "-1")
            .drive(mainView.currentPhotoCount.rx.text)
            .disposed(by: disposeBag)
    }
}

extension AddPhotosVC: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider)
        
        Observable.zip(itemProviders.map { getImage(with: $0) })
            .subscribe(
                with: self,
                onNext: { owner, images in
                    owner.viewModel.photoSelected(images: images)
                }
            )
            .disposed(by: disposeBag)
        
        func getImage(with item: NSItemProvider) -> Observable<UIImage> {
            return Observable<UIImage>.create { observer in
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
                    })
                } else {
                    Log.error("이미지 load 불가능")
                }
                return Disposables.create()
            }
        }
    }
}

private extension AddPhotosVC {
    
    func getDataSourece() -> RxCollectionViewSectionedAnimatedDataSource<PhotoSection> {
        return RxCollectionViewSectionedAnimatedDataSource(configureCell: { _, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddPhotoCVC.identifier,
                for: indexPath
            ) as? AddPhotoCVC else { return UICollectionViewCell() }
            cell.configCell(with: item)
            if indexPath.item == 0 { cell.showThumbnailMask() }
                
            return cell
        })
    }
    
}

//extension AddPhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddPhotoCVC.self), for: indexPath) as? AddPhotoCVC else { return UICollectionViewCell() }
//        return cell
//    }
//}
