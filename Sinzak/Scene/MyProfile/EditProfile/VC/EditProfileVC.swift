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
    private var viewModel: EditProfileVM
    private let disposeBag = DisposeBag()
    private var profile: Profile
    
    private lazy var updateImage: (UIImage?, Bool) -> Void = { [weak self] image, isIcon  in
        guard let self = self else { return }
        
        self.mainView.profileImage.image = image
        self.viewModel.needUpdateImage = (true, image, isIcon)
    }
    
    init(profile: Profile, viewModel: EditProfileVM) {
        self.profile = profile
        self.mainView.configureProfile(with: profile)
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
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
        
        let complete = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        let dismiss = UIBarButtonItem(
            image: UIImage(named: "dismiss")?.withTintColor(CustomColor.label, renderingMode: .alwaysOriginal),
            style: .plain, target: nil, action: nil
        )
        
        navigationItem.leftBarButtonItem = dismiss
        navigationItem.rightBarButtonItem = complete
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    
                    if owner.viewModel.needUpdateImage.need == true {
                        owner.showPopUpAlert(
                            message: "화면을 나가면 이미지 변경사항은 저장되지 않습니다. 나가시겠습니까?",
                            rightActionTitle: "나가기",
                            rightActionCompletion: {
                                owner.dismiss(animated: true)
                            }
                        )
                    } else {
                        owner.dismiss(animated: true)
                    }
                })
            .disposed(by: disposeBag)
        
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
                            
                            let image = profileIcons[
                                Int.random(in: 0..<profileIcons.count)
                            ]
                            owner.mainView.profileImage.image = image
                            owner.viewModel.needUpdateImage = (true, image, true)
                        }
                    )
            })
            .disposed(by: disposeBag)
        
        let tapGestureOfNicknameView = UITapGestureRecognizer()
        mainView.nicknameView.addGestureRecognizer(tapGestureOfNicknameView)
        tapGestureOfNicknameView.rx.event
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    let vc = ValidateNameVC(
                        validateNameViewControllerType: .editProfile,
                        viewModel: DefaultValidateNameVM(
                            introduction: owner.profile.introduction,
                            changedNickname: owner.viewModel.changedNicknameRelay
                        )
                    )
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    owner.present(nav, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        let tapGestureOfIntroductionView = UITapGestureRecognizer()
        mainView.introductionView.addGestureRecognizer(tapGestureOfIntroductionView)
        tapGestureOfIntroductionView.rx.event
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    let vc = EditIntroductionVC(
                        name: owner.profile.name,
                        introduction: owner.profile.introduction,
                        changedIntroduction: owner.viewModel.changedIntroductionRelay
                    )
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    
                    owner.present(nav, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        mainView.verifySchoolButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    let vm = DefaultUniversityInfoVM(
                        updateSchoolAuth: owner.viewModel.updateSchoolAuthRelay
                    )
                    let vc = UniversityInfoVC(viewModel: vm, mode: .editProfile)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    owner.present(nav, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        mainView.changeGenreButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    let vm = DefaultSignupGenreVM(
                        updateGenre: owner.viewModel.updateGenreRelay
                    )
                    let vc = SignupGenreVC(viewModel: vm, mode: .editProfile)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    owner.present(nav, animated: true)
                    
                })
            .disposed(by: disposeBag)
    
        navigationItem.rightBarButtonItem?.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.showLoading()
                    owner.viewModel.completeButtonTapped(currentName: owner.profile.name)
                })
            .disposed(by: disposeBag)
        
    }
    
    func  bindOutput() {
        
        viewModel.changedNicknameRelay
            .asSignal()
            .do(onNext: { [weak self] name in
                self?.profile.name = name
            })
            .emit(to: mainView.currentNickNameLabel.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.changedIntroductionRelay
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, introduction in
                    if introduction.isEmpty {
                        owner.mainView.currentIntroductionLabel.textColor = CustomColor.gray60
                        owner.mainView.currentIntroductionLabel.text = "소개를 입력하세요."
                    } else {
                        owner.mainView.currentIntroductionLabel.textColor = CustomColor.label
                        owner.mainView.currentIntroductionLabel.text = introduction
                    }
                    owner.profile.introduction = introduction
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.updateSchoolAuthRelay
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, school in
                    owner.mainView.schoolNameLabel.text = school
                    owner.mainView.verifySchoolButton.isEnabled = false
                })
            .disposed(by: disposeBag)
        
        viewModel.updateGenreRelay
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, genres in
                    let genres: String = genres
                        .map { $0.text }
                        .joined(separator: "\n")
                    
                    owner.mainView.genreNameLabel.text = genres
                })
            .disposed(by: disposeBag)
        
        viewModel.completeEditTasksRelay
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.hideLoading()
                    owner.dismiss(animated: true)
                })
            .disposed(by: disposeBag)
        
        viewModel.errorHandlerRelay
            .asSignal()
            .emit(with: self, onNext: { owner, error in
                owner.hideLoading()
                owner.simpleErrorHandler.accept(error)
            })
            .disposed(by: disposeBag)
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
                        self?.viewModel.needUpdateImage = (true, image, false)
                    }
                }
            })
        }
    }
}
