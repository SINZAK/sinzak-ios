//
//  ReportView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/01.
//

import UIKit

final class ReportView: SZView {
    
    // MARK: - Property
    
    let type: String
    
    // MARK: - UI
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.label
        label.font = .body_B
        label.text = "신고 내용을 작성해주세요."

        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray80
        label.font = .body_B
        label.text = ": \(type)"

        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = CustomColor.label
        textView.tintColor = CustomColor.red
        textView.backgroundColor = CustomColor.gray10
        textView.layer.cornerRadius = 40.0
        textView.contentInset = UIEdgeInsets(top: 16.0, left: 28.0, bottom: 16.0, right: 28.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        textView.typingAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.body_R,
            NSAttributedString.Key.foregroundColor: CustomColor.label
        ]
        textView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 16.0, left: 0, bottom: 16.0, right: 20.0)
        
        return textView
    }()
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray60
        label.font = .body_R
        label.text = "신작이 조치를 취해드릴 수 있게 문제 상황을 최대한 구체적으로 설명해주세요."
        label.numberOfLines = 2
        label.addInterlineSpacing()
        
        return label
    }()
    
    lazy var letterCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .caption_R
        label.textColor = CustomColor.gray80
        label.text = "글자 수 제한 0/300"
        
        return label
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .caption_M
        label.textColor = CustomColor.gray80
        label.text = "신고하면 더 이상 서로 채팅을 보낼 수 없어요."
        
        return label
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle("신고하기", for: .normal)
        button.titleLabel?.font = .body_B
        button.titleLabel?.textColor = CustomColor.white
        button.backgroundColor = CustomColor.red
        button.layer.cornerRadius = 32.0
        
        return button
    }()
    
    init(type: String) {
        self.type = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setView() {
        addSubviews(
            infoLabel,
            typeLabel,
            textView,
            placeHolderLabel,
            letterCounterLabel,
            warningLabel,
            reportButton
        )
    }
    
    override func setLayout() {
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24.0)
            $0.leading.equalToSuperview().inset(32.0)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(4.0)
            $0.leading.equalTo(infoLabel)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(252)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.top.equalTo(textView).offset(textView.textContainerInset.top + 16.0)
            $0.leading.equalTo(textView).offset(textView.textContainerInset.left + 32.0)
            $0.trailing.equalTo(textView).offset(-textView.textContainerInset.left - 28.0)
        }
        
        letterCounterLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12.0)
            $0.trailing.equalToSuperview().inset(48.0)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(reportButton.snp.top).offset(-2.0)
        }
        
        reportButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8.0)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-24.0)
            $0.height.equalTo(64.0)
        }

    }
}
