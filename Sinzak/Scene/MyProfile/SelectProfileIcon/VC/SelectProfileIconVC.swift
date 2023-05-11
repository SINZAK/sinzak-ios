//
//  SelectProfileIconVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PhotosUI

final class SelectProfileIconVC: SZVC {
    
    private let mainView = SelectProfileIconView()
    private let disposeBag = DisposeBag()
    private let updateImage: (UIImage?) -> Void
    
    override func loadView() {
        view = mainView
    }
    
    init(updateImage: @escaping (UIImage?) -> Void) {
        self.updateImage = updateImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setNavigationBar() {
        let dissBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "dismiss"),
            style: .plain,
            target: nil,
            action: nil
        )
        dissBarButtonItem.tintColor = CustomColor.label
        
        let completeBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: nil,
            action: nil
        )
        completeBarButtonItem.tintColor = CustomColor.label
        
        navigationItem.leftBarButtonItem = dissBarButtonItem
        navigationItem.rightBarButtonItem = completeBarButtonItem
    }
    
    override func configure() {
        bind()
    }
    
    func bind() {
        
        let profileIcons: [UIImage?] = [
            UIImage(named: "profile-icon-1"),
            UIImage(named: "profile-icon-2"),
            UIImage(named: "profile-icon-3"),
            UIImage(named: "profile-icon-4"),
            UIImage(named: "profile-icon-5"),
            UIImage(named: "profile-icon-6"),
            UIImage(named: "profile-icon-7"),
            UIImage(named: "profile-icon-8"),
            UIImage(named: "profile-icon-9"),
            UIImage(named: "profile-icon-10")
        ]
        let sections = [
            SectionModel(model: "", items: profileIcons)
        ]
        let dataSource = getDataSource()
        Observable.just(sections)
            .bind(to: mainView.selectCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        mainView.selectCollectionView.rx.modelSelected(UIImage?.self)
            .asDriver()
            .drive(with: self, onNext: { owner, image in
                owner.mainView.selectedImageView.image = image
            })
            .disposed(by: disposeBag)
        
        mainView.selectInAlbumButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.showPHPicker()
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    owner.dismiss(animated: true)
                    
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    let image = owner.mainView.selectedImageView.image
                    owner.updateImage(image)
                    owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}

private extension SelectProfileIconVC {
    
    func getDataSource() ->  RxCollectionViewSectionedReloadDataSource<SectionModel<String, UIImage?>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, UIImage?>>(configureCell: { _, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectIconCVC.identifier,
                for: indexPath
            ) as? SelectIconCVC else { return UICollectionViewCell() }
            
            cell.configImage(with: item)
            
            return cell
        })
    }
    
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.view.tintColor = CustomColor.red
        picker.modalPresentationStyle = .fullScreen
        
        present(picker, animated: true)
    }

}

extension SelectProfileIconVC: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        
        dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                if let error = error {
                    Log.error(error)
                    return
                }
                
                if let image = image as? UIImage {
                    DispatchQueue.main.async { [weak self] in
                        self?.mainView.selectedImageView.image = image
                    }
                }
            })
        }
    }
}
