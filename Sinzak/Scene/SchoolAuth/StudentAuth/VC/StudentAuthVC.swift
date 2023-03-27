//
//  StudentAuthVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import YPImagePicker
import RxSwift
import RxCocoa
import RxKeyboard

final class StudentAuthVC: SZVC {
    // MARK: - Properties
    private let mainView = StudentAuthView()
    var authType = SchoolAuthType.webmail
    var viewModel = SchoolAuthViewModel()
    var schoolcardImage: UIImage? = UIImage()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @objc func doNextButtonTapped(_ sender: UIButton) {
        let vc = WelcomeVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc func finishButtonTapped(_ sender: UIButton) {
        // 학생증 인증 API 보내기
        switch authType {
        case .webmail:
            print("webmail")
        case .idcard:
            print("idcard")
        }
        // 웰컴화면으로 보내기
        let vc = WelcomeVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.webmailButton.addTarget(self, action: #selector(webmailButtonTapped), for: .touchUpInside)
        mainView.schoolcardButton.addTarget(self, action: #selector(schoolCardButtonTapped), for: .touchUpInside)
        mainView.doNextButton.addTarget(self, action: #selector(doNextButtonTapped), for: .touchUpInside)
        mainView.finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.schoolAuth
    }
    func bind() {
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
                let color: UIColor = bool  ? CustomColor.purple! : CustomColor.red!
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
                let color: UIColor = bool  ? CustomColor.purple! : CustomColor.red!
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
        // 키보드 자동 설정
        RxKeyboard.instance.visibleHeight
            .drive(with: self, onNext: { (vc, keyboardHeight) in
             print("keyBoard 높이는 \(keyboardHeight) 입니다.")
             if keyboardHeight > 0 {
                 vc.mainView.buttonStack.snp.updateConstraints { make in
                     make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(-keyboardHeight + self.mainView.safeAreaInsets.bottom - 20)
                     vc.mainView.layoutIfNeeded()
                 }
             } else {
                 vc.mainView.buttonStack.snp.updateConstraints { make in
                     make.bottom.equalTo(self.mainView.safeAreaLayoutGuide)
                     vc.mainView.layoutIfNeeded()
                 }
             }
         })
         .disposed(by: viewModel.disposeBag)
    }
}
