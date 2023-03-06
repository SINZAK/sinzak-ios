//
//  StudentAuthVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit

final class StudentAuthVC: SZVC {
    // MARK: - Properties
    private let mainView = StudentAuthView()
    var authType = SchoolAuthType.webmail
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
    @objc func photoUploadButtonTapped(_ sender: UIButton) {
        // 사진 첨부가 성공했을 경우
        mainView.photoUploadButton.isHidden = true
        mainView.uploadedPhotoView.isHidden = false
    }
    @objc func cancelPhotoButtonTapped(_ sender: UIButton) {
        // 이미지 삭제할지 알람 띄우기
        mainView.photoUploadButton.isHidden = false
        mainView.uploadedPhotoView.isHidden = true
    }
    // MARK: - Helpers
    override func configure() {
        mainView.webmailButton.addTarget(self, action: #selector(webmailButtonTapped), for: .touchUpInside)
        mainView.schoolcardButton.addTarget(self, action: #selector(schoolCardButtonTapped), for: .touchUpInside)
        mainView.doNextButton.addTarget(self, action: #selector(doNextButtonTapped), for: .touchUpInside)
        mainView.finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        mainView.photoUploadButton.addTarget(self, action: #selector(photoUploadButtonTapped), for: .touchUpInside)
        mainView.cancelButton.addTarget(self, action: #selector(cancelPhotoButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.schoolAuth
    }
}
