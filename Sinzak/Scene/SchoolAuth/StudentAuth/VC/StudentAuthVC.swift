//
//  StudentAuthVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import PhotosUI

final class StudentAuthVC: SZVC {
    // MARK: - Properties
    private let mainView = StudentAuthView()
    var authType = SchoolAuthType.webmail
    var viewModel: StudentAuthVM
    var mode: EditViewMode
    var schoolcardImage: UIImage? = UIImage()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: StudentAuthVM, mode: EditViewMode) {
        self.viewModel = viewModel
        self.mode = mode
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: - Actions
    @objc func webmailButtonTapped(_ sender: UIButton) {
        mainView.changeButtonStatus(.webmail)
        authType = .webmail
        // 웹메일용 뷰 보여주기
        mainView.webmailView.isHidden = false
        mainView.schoolCardView.isHidden = true
    }
    @objc func schoolCardButtonTapped(_ sender: UIButton) {
        mainView.changeButtonStatus(.idcard)
        authType = .idcard
        // 학생증 인증용 뷰 보여주기
        mainView.schoolCardView.isHidden = false
        mainView.webmailView.isHidden = true
    }

    // MARK: - Helpers
    override func configure() {
        mainView.webmailButton.addTarget(self, action: #selector(webmailButtonTapped), for: .touchUpInside)
        mainView.schoolcardButton.addTarget(self, action: #selector(schoolCardButtonTapped), for: .touchUpInside)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(touch)
        
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "학교 인증"
    }
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        mainView.webmailTextField.rx.text
            .orEmpty
            .skip(1)
            .bind(
                with: self,
                onNext: { owner, text in
                    owner.viewModel.webMailTextInput(text: text)
                }
            )
            .disposed(by: disposeBag)
        
        mainView.webmailTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(
                with: self,
                onNext: { owner, _ in
                    guard owner.viewModel.webMailTextValidResult.value == .valid else { return }
                    
                    owner.viewModel.tranmitUnivMail()
                }
            )
            .disposed(by: disposeBag)
        
        mainView.transmitMailButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.mainView.transmitMailButton.isEnabled = false
                    owner.viewModel.tranmitUnivMail()
                }
            )
            .disposed(by: disposeBag)
        
        let authCodeText =  mainView.authCodeTextField.rx.text
            .orEmpty
            .share()
        
        authCodeText
            .map { $0.count == 4 && Int($0) != nil }
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.confirmCodeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        authCodeText
            .map { $0.count == 4 && Int($0) != nil }
            .asSignal(onErrorJustReturn: false)
            .emit(
                with: self,
                onNext: { owner, isValid in
                    switch isValid {
                    case true:
                        owner.mainView.authCodeValidationLabel.text = ""
                    case false:
                        owner.mainView.authCodeValidationLabel.text = "다시 입력해주세요."
                        owner.mainView.authCodeValidationLabel.textColor = CustomColor.red
                    }
            })
            .disposed(by: disposeBag)
        
        mainView.authCodeTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(
                with: self,
                onNext: { owner, _ in
                    let code: Int = Int(owner.mainView.authCodeTextField.text ?? "") ?? 0
                    owner.viewModel.certifyUnivEmailCode(code: code)
                }
            )
            .disposed(by: disposeBag)

        mainView.confirmCodeButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    let code: Int = Int(owner.mainView.authCodeTextField.text ?? "") ?? 0
                    owner.viewModel.certifyUnivEmailCode(code: code)
                }
            )
            .disposed(by: disposeBag)
        
        mainView.photoUploadButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    var configuration = PHPickerConfiguration()
                    configuration.selectionLimit = 1
                    configuration.filter = .images
                    
                    let picker = PHPickerViewController(configuration: configuration)
                    picker.delegate = self
                    picker.view.tintColor = CustomColor.red
                    picker.modalPresentationStyle = .fullScreen
                    
                    owner.present(picker, animated: true)
                })
            .disposed(by: disposeBag)
        
        mainView.webMailDoNextButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    switch owner.mode {
                    case .signUp:
                        let vc = WelcomeVC()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    case .editProfile:
                        owner.dismiss(animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        mainView.webMailFinishButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    switch owner.mode {
                    case .signUp:
                        let vc = WelcomeVC()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    case .editProfile:
                        owner.dismiss(animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        mainView.schoolCardDoNextButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    switch owner.mode {
                    case .signUp:
                        let vc = WelcomeVC()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    case .editProfile:
                        owner.dismiss(animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        mainView.schoolCardFinishButton.rx.tap
            .bind(
                with: self,
                onNext: { owner, _ in
                    
                    let image = owner.mainView.uploadedImageView.image ?? UIImage()
                    owner.showLoading()
                    owner.viewModel.transmitSchoolCar(image: image)
                    
                }
            )
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        let webMailTextValidResult = viewModel.webMailTextValidResult
            .skip(1)
            .asDriver(onErrorJustReturn: .notValid)
        
        webMailTextValidResult
            .drive(with: self, onNext: { owner, result in
                owner.mainView.webmailValidationLabel.text = result.info
                owner.mainView.webmailValidationLabel.textColor = result.color
            })
            .disposed(by: disposeBag)
        
        webMailTextValidResult
            .map { $0 == .valid }
            .drive(mainView.transmitMailButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.errorHandler
            .subscribe(
                with: self,
                onNext: { owner, error in
                    owner.simpleErrorHandler.accept(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.transmitUnivMailErrorHandler
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, error in
                    owner.simpleErrorHandler.accept(error)
                    owner.mainView.transmitMailButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        viewModel.showAuthCodeView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, _ in
                owner.mainView.webmailTextField.isEnabled = false
                owner.viewModel.webMailTextValidResult.accept(.authComplete)
                
                UIView.animate(
                    withDuration: 0.5,
                    delay: .zero,
                    animations: {
                        [
                            owner.mainView.authCodeLabel,
                            owner.mainView.authCodeTextField,
                            owner.mainView.confirmCodeButton,
                            owner.mainView.authCodeValidationLabel
                        ].forEach {
                            $0.isHidden = false
                            $0.alpha = 1
                        }
                    })
                
                UIView.transition(
                    with: owner.mainView.authCodeLabel,
                    duration: 0.5,
                    animations: {
                        owner.mainView.authCodeLabel.textColor = CustomColor.label.withAlphaComponent(1)
                    }
                )
                
            })
            .disposed(by: disposeBag)
        
        viewModel.completeEmailCertify
            .asSignal(onErrorJustReturn: false)
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.mainView.authCodeTextField.isEnabled = false
                    owner.mainView.confirmCodeButton.isEnabled = false
                    owner.mainView.authCodeValidationLabel.textColor = CustomColor.purple
                    owner.mainView.authCodeValidationLabel.text = "인증 완료!"
                    owner.mainView.webMailFinishButton.isEnabled = true
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.completeSchoolCardCertify
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.hideLoading()
                    switch owner.mode {
                    case .signUp:
                        let vc = WelcomeVC()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    case .editProfile:
                        owner.dismiss(animated: true)
                    }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PHPicker
extension StudentAuthVC: PHPickerViewControllerDelegate {
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
                        self?.mainView.uploadedImageView.image = image
                        self?.mainView.schoolCardFinishButton.isEnabled = true
                    }
                }
            })
        }
    }
}

// MARK: - Private Method
private extension StudentAuthVC {
    @objc func endEditing() {
        self.view.endEditing(true)
    }
}
