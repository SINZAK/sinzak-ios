//
//  EditIntroductionVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/07/13.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit

final class EditIntroductionVC: SZVC {
    
    // MARK: - Property
    
    private let disposeBag = DisposeBag()
    
    private let name: String
    private let introduction: String
    
    private let changedIntroduction: PublishRelay<String>
    
    // MARK: - UI
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray60
        label.font = .body_M
        label.text = "소개글을 작성해주세요."
        
        return label
    }()
    
    private let introductionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .body_R
        textView.backgroundColor = CustomColor.gray10
        textView.layer.cornerRadius = 20.0
        textView.tintColor = CustomColor.red
        textView.textContainerInset = UIEdgeInsets(
            top: 18.0,
            left: 18.0,
            bottom: 18.0,
            right: 18.0
        )
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private let limitInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray80
        label.font = .caption_R
        label.text = "글자 수 제한 "
        
        return label
    }()
    
    private let limitNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray80
        label.font = .caption_R
        label.text = "0/100"
        
        return label
    }()
    
    private let confirmButton = SZButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .body_B
        $0.backgroundColor = CustomColor.red
        $0.layer.cornerRadius = 30
    }
    
    // MARK: - init
    
    init(
        name: String,
        introduction: String,
        changedIntroduction: PublishRelay<String>
    ) {
        self.name = name
        self.introduction = introduction
        self.changedIntroduction = changedIntroduction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        introductionTextView.becomeFirstResponder()
    }
    
    // MARK: - Configure
    
    override func configure() {
        configureView()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func configureView() {
        
        navigationItem.title = "소개"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SZImage.Icon.dismiss,
            style: .plain,
            target: nil,
            action: nil
        )
        
        introductionTextView.text = introduction
        
        [
            infoLabel,
            introductionTextView,
            limitInfoLabel, limitNumberLabel,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28.0)
            $0.leading.equalToSuperview().inset(22.0)
        }
        
        introductionTextView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(140.0)
        }
        
        limitNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22.0)
            $0.top.equalTo(introductionTextView.snp.bottom).offset(10.0)
        }
        limitInfoLabel.snp.makeConstraints {
            $0.trailing.equalTo(limitNumberLabel.snp.leading)
            $0.top.equalTo(limitNumberLabel)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(7.4)
            $0.height.equalTo(65)
            $0.bottom.equalToSuperview().inset(24.0).inset(24.0)
        }
    }
    
    func bind() {
        
        navigationItem.leftBarButtonItem?.rx.tap
            .asSignal()
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.dismiss(animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] keyboardVisibleHeignt in
                guard let self = self else { return }
                if keyboardVisibleHeignt > 0 {
                    self.confirmButton.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(keyboardVisibleHeignt + 16.0)
                    }
                    self.view.layoutIfNeeded()
                    
                } else {
                    self.confirmButton.snp.updateConstraints {
                        $0.bottom.equalToSuperview().inset(24.0)
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        let introductionText = introductionTextView.rx.text
            .orEmpty
            .asDriver()
        
        introductionText
            .map { $0.count }
            .filter { $0 > 100 }
            .drive(
                with: self,
                onNext: { owner, _ in
                    let text = owner.introductionTextView.text ?? ""
                    owner.introductionTextView.text = String(text.prefix(100))
            })
            .disposed(by: disposeBag)
        
        introductionText
            .map { $0.count }
            .drive(
                with: self,
                onNext: { owner, count in
                    owner.limitNumberLabel.text = "\(count)/100"
                }
            )
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .throttle(
                .milliseconds(500),
                scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
            )
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    
                    let introduction: String = owner.introductionTextView.text
                    UserCommandManager.shared.editUserInfo(
                        name: owner.name,
                        introduction: introduction
                    )
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { _ in
                            owner.changedIntroduction.accept(introduction)
                            owner.dismiss(animated: true)
                        }, onFailure: { error in
                            Log.error(error)
                        }
                    )
                    .disposed(by: owner.disposeBag)
                }
            )
            .disposed(by: disposeBag)
    }

}
