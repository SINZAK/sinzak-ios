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
        navigationItem.title = I18NStrings.schoolAuth
    }
    func bind() {
        /*
        // 사진 업로드
        mainView.photoUploadButton.rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                let picker = YPImagePicker()
                picker.didFinishPicking { [unowned picker] items, _ in
                    if let photo = items.singlePhoto {
                        // 사진 첨부가 성공했을 경우
                        vc.schoolcardImage = photo.image
                        vc.mainView.photoUploadButton.isHidden = true
                        vc.mainView.photoNameLabel.text = String.uniqueFilename(withPrefix: "IMG", fileExtension: "jpg")
                        vc.mainView.uploadedPhotoView.isHidden = false
                        vc.mainView.selectedPhoto.isHidden = false
                        vc.mainView.selectedPhoto.image = photo.image
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                vc.present(picker, animated: true, completion: nil)
            }
            .disposed(by: viewModel.disposeBag)
        // 사진 취소
        mainView.cancelButton.rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                // 이미지 삭제할지 알람 띄우기
                vc.showAlert(title: "이미지를 삭제하시겠습니까?", okText: "삭제", cancelNeeded: true) { _ in
                    vc.mainView.photoUploadButton.isHidden = false
                    vc.mainView.uploadedPhotoView.isHidden = true
                    vc.mainView.selectedPhoto.isHidden = true
                    // 사진 삭제
                    vc.schoolcardImage = nil
                }
            }
            .disposed(by: viewModel.disposeBag)
        // 텍스트필드쪽
        let mailValidation = mainView.webmailTextField.rx.text
            .orEmpty
            .map {
              $0.isValidString(.email)
            }
            .share()
        mailValidation
            .withUnretained(self)
            .bind { (vc, bool) in
                let text: String = bool ? "엔터를 눌러 인증메일을 전송해주세요" : I18NStrings.enterYourEmailInCorrectFormat
                let color: UIColor = bool  ? CustomColor.purple : CustomColor.red
                vc.mainView.webmailValidationLabel.textColor = color
                vc.mainView.webmailValidationLabel.text = text
            }
            .disposed(by: viewModel.disposeBag)
        mainView.webmailTextField.rx
            .controlEvent([.editingDidEndOnExit])
            .withUnretained(self)
            .bind { (vc, _) in
                // 인증메일 전송
                vc.mainView.webmailValidationLabel.text = "인증메일이 전송되었습니다."
                vc.mainView.webmailTextField.isUserInteractionEnabled = false
                vc.mainView.layoutIfNeeded()
            }
            .disposed(by: viewModel.disposeBag)
        let authcodeValidation = mainView.authCodeTextField
            .rx.text
            .orEmpty
            .map { $0.isValidString(.digit)}
            .share()
        authcodeValidation
            .withUnretained(self)
            .bind { (vc, bool) in
                let text: String = bool ? "" :  I18NStrings.pleaseEnterAgain
                let color: UIColor = bool  ? CustomColor.purple : CustomColor.red
                vc.mainView.authCodeValidationLabel.textColor = color
                vc.mainView.authCodeValidationLabel.text = text
                vc.mainView.layoutIfNeeded()
            }
            .disposed(by: viewModel.disposeBag)
        mainView.authCodeTextField.rx
            .controlEvent([.editingDidEndOnExit])
            .withUnretained(self)
            .bind { (vc, _) in
                // 인증코드 전송되고 맞았을 때
                vc.mainView.authCodeValidationLabel.text = "인증완료"
                vc.mainView.layoutIfNeeded()
            }
            .disposed(by: viewModel.disposeBag)
         */

        /*
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeignt in
                guard let self = self else { return }
                Log.debug("keyboard: \(keyboardVisibleHeignt)")
                if keyboardVisibleHeignt > 0 {

//                    self.mainView.buttonStack.snp.updateConstraints {
//                        $0.bottom.equalToSuperview().inset(keyboardVisibleHeignt + 16.0)
//                    }
//                    self.mainView.webmailView.snp.updateConstraints {
//                        $0.bottom.equalTo(keyboardVisibleHeignt)
//                    }
                    let window = UIApplication.shared.windows.first
                    let extra = window!.safeAreaInsets.bottom
                    Log.debug("\(self.mainView.authCodeValidationLabel.frame.maxY + self.mainView.authButtonStack.frame.maxY > self.view.frame.height -  keyboardVisibleHeignt)")
                    
                    
//                        self.mainView.selectAuthTypeLabel.snp.updateConstraints { make in
//                            make.leading.equalToSuperview().inset(40)
//                            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(-32)
//                        }
//                        self.view.layoutIfNeeded()
//                    self.mainView.scrollView.contentInset.bottom = 100
//
//                    self.mainView.scrollView.scroll(to: .bottom)
//                    self.mainView.scrollView.

                } else {
//                    self.mainView.buttonStack.snp.updateConstraints {
//                        $0.bottom.equalToSuperview().inset(24.0)
//                    }
//                    self.mainView.selectAuthTypeLabel.snp.updateConstraints { make in
//                        make.leading.equalToSuperview().inset(40)
//                        make.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
//                    }
//                    self.view.layoutIfNeeded()
                    self.mainView.scrollView.contentInset.bottom = 0
                }
            })
            .disposed(by: disposeBag)
         */
        
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
            .bind(
                with: self,
                onNext: { owner, _ in
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
