//
//  EditProfileVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class EditProfileVC: SZVC {
    
    // MARK: - Properties
    private let mainView = EditProfileView()
    private let disposeBag = DisposeBag()
    let profile: Profile
    
    private lazy var updateImage: (UIImage?) -> Void = { [weak self] image in
        guard let self = self else { return }
        
        self.mainView.profileImage.image = image
    }
    
    init(profile: Profile) {
        self.profile = profile
        self.mainView.configureProfile(with: profile)
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
        Log.debug("tappppp!!!")
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func finishButtonTapped(_ sender: UIBarButtonItem) {
        // - 수정내용 저장하는 로직
        navigationController?.popViewController(animated: true)
    }
    @objc func applyAuthorButtonTapped(_ sender: UIButton) {
        let vc = CertifiedAuthorVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.applyAuthorButton.addTarget(self, action: #selector(applyAuthorButtonTapped), for: .touchUpInside)
        
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        
        let finish = UIBarButtonItem(title: I18NStrings.finish, style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItem = finish
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        let scrollViewTapGesture = UITapGestureRecognizer()
        mainView.scrollView.addGestureRecognizer(scrollViewTapGesture)
        scrollViewTapGesture.rx.event
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        mainView.changeProfileImageButton.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    owner.showTripleAlertSheet(
                        firstActionText: "앨범에서 사진 선택하기",
                        secondActionText: "프로필 아이콘 선택하기",
                        thirdActionText: "사진 삭제",
                        firstCompletion: {
                            owner.showPHPicker()
                        },
                        secondCompletion: {
                            let vc = SelectProfileIconVC(updateImage: owner.updateImage)
                            let nav = UINavigationController.init(rootViewController: vc)
                            nav.modalPresentationStyle = .fullScreen
                            owner.present(nav, animated: true)
                        },
                        thirdCompletion: {
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
                            
                            owner.mainView.profileImage.image = profileIcons[
                                Int.random(in: 0..<profileIcons.count)
                            ]
                        }
                    )
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
    }
}

private extension EditProfileVC {
    
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

extension EditProfileVC: PHPickerViewControllerDelegate {
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
                        self?.mainView.profileImage.image = image
                    }
                }
            })
        }
    }
}
