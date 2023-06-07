//
//  ReportVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/01.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportVC: SZVC {
    
    let userID: Int
    let type: String
    let mainView: ReportView
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = "사용자 신고"
    }
    
    // MARK: - Init
    
    init(userID: Int, type: String) {
        self.userID = userID
        self.type = type
        mainView = ReportView(type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func configure() {
        bind()
    }
    
    func bind() {
        let textViewInput = mainView.textView.rx.text
            .orEmpty
            .asDriver()
        
        textViewInput
            .map { !$0.isEmpty }
            .drive(mainView.placeHolderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        textViewInput
            .map { "글자 수 제한 \($0.count)/300" }
            .drive(mainView.letterCounterLabel.rx.text)
            .disposed(by: disposeBag)
            
        textViewInput
            .map { $0.count > 300 }
            .filter { $0 }
            .drive(with: self, onNext: { owner, _ in
                _ = owner.mainView.textView.text.removeLast()
            })
            .disposed(by: disposeBag)
        
        mainView.reportButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.showSinglePopUpAlert(message: "신고 완료", actionCompletion: {
                    owner.navigationController?.popToRootViewController(animated: true)
                })
                // TODO: 신고 API 연결 필요
                /*
                let reason = owner.type + "," + owner.mainView.textView.text
                UserCommandManager.shared.report(userId: owner.userID, reason: reason)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { _ in
                            owner.showSinglePopUpAlert(message: "신고 완료", actionCompletion: {
                                owner.navigationController?.popToRootViewController(animated: true)
                            })
                        },
                        onFailure: { error in
                            Log.error(error)
                            owner.navigationController?.popToRootViewController(animated: true)
                        })
                    .disposed(by: owner.disposeBag)
                 */
            })
            .disposed(by: disposeBag)
    }
}
