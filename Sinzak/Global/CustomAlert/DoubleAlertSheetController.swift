//
//  DoubleAlertSheetController.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit

final class DoubleAlertSheetController: UIViewController {
    
    static var maxHeight: CGFloat = 236.0
    let firstActionText: String
    let sectondActionText: String
    let cancelText: String
    
    private lazy var firstActionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.alertSheetBackground
        button.setTitle(firstActionText, for: .normal)
        button.setTitleColor(CustomColor.label, for: .normal)
        button.titleLabel?.font = .body_M
        
        return button
    }()
    
    private lazy var secondActionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.alertSheetBackground
        button.setTitle(sectondActionText, for: .normal)
        button.setTitleColor(CustomColor.alertTint2, for: .normal)
        button.titleLabel?.font = .body_M
        
        return button
    }()
        
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.alertSheetBackground
        button.layer.cornerRadius = 30.0
        button.setTitle(cancelText, for: .normal)
        button.setTitleColor(CustomColor.label, for: .normal)

        button.titleLabel?.font = .body_B
        
        return button
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = 30.0
        stackView.clipsToBounds = true
        
        return stackView
    }()
    
    private lazy var separtor: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.gray60
        
        return view
    }()
    
    // MARK: - Init
    init(firstActionText: String, secondActionText: String, cancelText: String) {
        self.firstActionText = firstActionText
        self.sectondActionText = secondActionText
        self.cancelText = cancelText
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
    }
    
    func addCompletionToButton(
        firstActionCompletion: (() -> Void)? = nil,
        secondActionCompletion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) {
        
        firstActionButton.addAction(for: .touchUpInside) { _ in
            firstActionCompletion?()
        }
        
        secondActionButton.addAction(for: .touchUpInside) { _ in
            secondActionCompletion?()
        }
        
        cancelButton.addAction(for: .touchUpInside) { _ in
            cancelCompletion?()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .clear
    }
    
    private func configureLayout() {
        
        actionStackView.addArrangedSubviews(
            firstActionButton,
            secondActionButton
        )
        
        view.addSubviews(
            cancelButton,
            actionStackView,
            separtor
        )
        
        actionStackView.snp.makeConstraints {
            $0.bottom.equalTo(cancelButton.snp.top).offset(-8.0)
            $0.leading.trailing.equalTo(cancelButton)
        }
        
        firstActionButton.snp.makeConstraints {
            $0.height.equalTo(70.0)
        }
        
        secondActionButton.snp.makeConstraints {
            $0.height.equalTo(70.0)
        }
         
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24.0)
            $0.leading.trailing.equalToSuperview().inset(8.0)
            $0.height.equalTo(64.0)
        }
        
        separtor.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(0.5)
            $0.centerY.equalTo(actionStackView)
        }
    }
}
