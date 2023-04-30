//
//  PopUpAlertController.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit

final class PopUpAlertController: UIViewController {
    
    private var titleText: String?
    private var messageText: String?
    private var confirmText: String?
    private var contentView: UIView?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.background
        view.layer.cornerRadius = 30.0
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20.0
        view.alignment = .center
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 14.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = .body_M
        label.numberOfLines = 0
        label.textColor = CustomColor.label

        return label
    }()
    
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil else { return nil }

        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = .body_M
        label.textColor = CustomColor.label
        label.numberOfLines = 0
        
        return label
    }()
    
    convenience init(
        titleText: String? = nil,
        messageText: String? = nil
    ) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText

        modalPresentationStyle = .overFullScreen
    }
    
    convenience init(contentView: UIView) {
        self.init()

        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubViews()
        makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    public func addActionToButton(
        title: String? = nil,
        titleColor: UIColor = .white,
        backgroundColor: UIColor = .blue,
        completion: (() -> Void)? = nil
    ) {
        guard let title = title else { return }
        
        let button = UIButton()
        button.titleLabel?.font = .body_R
        button.titleLabel?.textColor = CustomColor.white
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor

        // layer
        button.layer.cornerRadius = 24.0
        button.layer.masksToBounds = true

        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }
        
        button.snp.makeConstraints {
            $0.height.equalTo(48.0)
            $0.width.equalTo(132.0)
        }

        buttonStackView.addArrangedSubview(button)
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        view.backgroundColor = .black.withAlphaComponent(0.2)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissAlert)
        )
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func addSubViews() {
        
        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }
            
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
        }

        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32.0)
            $0.top.greaterThanOrEqualTo(containerStackView)
            $0.bottom.greaterThanOrEqualTo(containerStackView)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(20.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    private func dismissAlert() {
        dismiss(animated: false)
    }
}

extension PopUpAlertController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        
        let tap = touch.location(in: self.view)
        if containerView.frame.contains(tap) { return false }
        else { return true }
    }
}

extension UIViewController {
    func showPopUpAlert(
        message: String,
        leftActionTitle: String,
        rightActionTitle: String,
        leftActionCompletion: (() -> Void)? = nil,
        rightActionCompletion: (() -> Void)? = nil
    ) {
        let popUpAlertController = PopUpAlertController(messageText: message)
        showPopUp(
            popUpViewController: popUpAlertController,
            leftActionTitle: leftActionTitle,
            rightActionTitle: rightActionTitle,
            leftActionCompletion: leftActionCompletion,
            rightActionCompletion: rightActionCompletion
        )
    }
    
    private func showPopUp(
        popUpViewController: PopUpAlertController,
        leftActionTitle: String?,
        rightActionTitle: String,
        leftActionCompletion: (() -> Void)?,
        rightActionCompletion: (() -> Void)?
    ) {
        
        popUpViewController.addActionToButton(
            title: leftActionTitle,
            titleColor: CustomColor.purple,
            backgroundColor: CustomColor.gray10,
            completion: {
                popUpViewController.dismiss(
                    animated: false,
                    completion: leftActionCompletion
                )
            }
        )
        popUpViewController.addActionToButton(
            title: rightActionTitle,
            titleColor: CustomColor.white,
            backgroundColor: CustomColor.purple,
            completion: {
                popUpViewController.dismiss(
                    animated: false,
                    completion: rightActionCompletion
                )
            }
        )
        present(popUpViewController, animated: false)
    }
}
