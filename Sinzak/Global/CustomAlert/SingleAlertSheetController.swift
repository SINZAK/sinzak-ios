//
//  SingleAlertSheetController.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit

final class SingleAlertSheetController: UIViewController {
    
    static var maxHeight: CGFloat = 166.0
    let actionText: String
    let cancelText: String
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.alertSheetBackground
        button.layer.cornerRadius = 30.0
        button.setTitle(actionText, for: .normal)
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
    
    // MARK: - Init
    init(actionText: String, cancelText: String) {
        self.actionText = actionText
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
        actionCompletion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) {
        cancelButton.addAction(for: .touchUpInside) { _ in
            cancelCompletion?()
        }
        
        actionButton.addAction(for: .touchUpInside) { _ in
            actionCompletion?()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .clear
    }
    
    private func configureLayout() {
        
        view.addSubviews(
            cancelButton,
            actionButton
        )
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24.0)
            $0.leading.trailing.equalToSuperview().inset(8.0)
            $0.height.equalTo(64.0)
        }
        
        actionButton.snp.makeConstraints {
            $0.bottom.equalTo(cancelButton.snp.top).offset(-8.0)
            $0.leading.trailing.equalTo(cancelButton)
            $0.height.equalTo(70.0)
        }
    }
}
