//
//  SZVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

class SZVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let needLogIn: PublishRelay<Bool> = .init()
    
    /**
     에러 message가 있으면 alert로 보여줍니다.
     message가 없으며 log로 보여줍니다.
     */
    let simpleErrorHandler: PublishRelay<Error> = .init()
    
    lazy var hud: JGProgressHUD = {
        let loader = JGProgressHUD()
                
        return loader
    }()
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hud.show(in: self.view, animated: true)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hud.dismiss(animated: true)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configure()
        view.backgroundColor = CustomColor.background
        
        needLogIn
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.7)
                owner.showNeedLogIn()
            })
            .disposed(by: disposeBag)
        
        simpleErrorHandler
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, error in
                if error is APIError {
                    let apiError = error as! APIError
                    
                    switch apiError {
                    case .errorMessage(let message):
                        owner.showSinglePopUpAlert(message: message)
                    default:
                        owner.showSinglePopUpAlert(message: "알 수 없는 오류가 발생했습니다.")
                    }
                } else {
                    owner.showSinglePopUpAlert(message: "알 수 없는 오류가 발생했습니다.")
                }
                Log.error(error)
            })
            .disposed(by: disposeBag)
    }
    /// 네비게이션 바 설정.
    func setNavigationBar() {
        // 색상 설정
        navigationController?.navigationBar.tintColor = CustomColor.label
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.body_B
        ]
        // 루트뷰가 아닐 경우 백버튼
        if self != navigationController?.viewControllers.first {
            let customBackButton = UIBarButtonItem(
                image: UIImage(named: "back")?.withTintColor(CustomColor.label, renderingMode: .alwaysOriginal),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped) )
            navigationItem.leftBarButtonItem = customBackButton
            
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.delegate = self
    }
    @objc
    func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    /// VC에서 실행할 메서드
    func configure() {
    }
}

// MARK: - Navigation Pop Gesture
extension SZVC: UIGestureRecognizerDelegate {}

extension SZVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1 && !(self is UniversityInfoVC)
    }
}

// MARK: - Popup Alert
extension UIViewController {
    
    func showNeedLogIn() {
        showPopUpAlert(
            message: "로그인 후 이용가능합니다.",
            rightActionTitle: "로그인하기",
            rightActionCompletion: { [weak self] in
                let vm = DefaultLoginVM()
                let vc = LoginVC(viewModel: vm)
                vc.configureDismissButton()
                
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                
                self?.present(nav, animated: true)
            }
        )
    }
    
    func showPopUpAlert(
        message: String,
        leftActionTitle: String = "아니요",
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
    
    func showSinglePopUpAlert(
        message: String,
        actionTitle: String = "확인",
        actionCompletion: (() -> Void)? = nil
    ) {
        let popUpAlertController = PopUpAlertController(messageText: message)
        popUpAlertController.addActionToButton(
            title: actionTitle,
            titleColor: CustomColor.white,
            backgroundColor: CustomColor.alertTint1,
            completion: {
                popUpAlertController.dismiss(
                    animated: false,
                    completion: { actionCompletion?() }
                )
            }
        )
        present(popUpAlertController, animated: false)
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
            titleColor: CustomColor.alertTint1,
            backgroundColor: CustomColor.alertCancel,
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
            backgroundColor: CustomColor.alertTint1,
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

// MARK: - Alert Sheet
extension SZVC: UIViewControllerTransitioningDelegate {
    
    func showSingleAlertSheet(
        actionTitle: String,
        cancelTitle: String = "취소",
        completion: (() -> Void)? = nil,
        cacelcompletion: (() -> Void)? = nil
    ) {
        let singleAlertSheet = SingleAlertSheetController(
            actionText: actionTitle,
            cancelText: cancelTitle
        )
        singleAlertSheet.addCompletionToButton(
            actionCompletion: {
                singleAlertSheet.dismiss(animated: true, completion: completion)
            },
            cancelCompletion: {
                singleAlertSheet.dismiss(animated: true, completion: cacelcompletion)
            }
        )
        singleAlertSheet.modalPresentationStyle = .custom
        singleAlertSheet.transitioningDelegate = self
        present(singleAlertSheet, animated: true)
    }
    
    func showNoTintSingleAlertSheet(
        actionTitle: String,
        cancelTitle: String = "취소",
        completion: (() -> Void)? = nil,
        cacelcompletion: (() -> Void)? = nil
    ) {
        let singleAlertSheet = SingleAlertSheetController(
            actionText: actionTitle,
            cancelText: cancelTitle
        )
        singleAlertSheet.actionButton.setTitleColor(CustomColor.label, for: .normal)
        singleAlertSheet.addCompletionToButton(
            actionCompletion: {
                singleAlertSheet.dismiss(animated: true, completion: completion)
            },
            cancelCompletion: {
                singleAlertSheet.dismiss(animated: true, completion: cacelcompletion)
            }
        )
        singleAlertSheet.modalPresentationStyle = .custom
        singleAlertSheet.transitioningDelegate = self
        present(singleAlertSheet, animated: true)
    }

    func showDoubleAlertSheet(
        firstActionText: String,
        secondActionText: String,
        cancelText: String = "취소",
        firstCompletion: (() -> Void)? = nil,
        secondCompletion: (() -> Void)? = nil,
        cacelcompletion: (() -> Void)? = nil
    ) {
        let doubleAlertSheet = DoubleAlertSheetController(
            firstActionText: firstActionText,
            secondActionText: secondActionText,
            cancelText: cancelText
        )
        doubleAlertSheet.addCompletionToButton(
            firstActionCompletion: {
                doubleAlertSheet.dismiss(animated: true, completion: firstCompletion)
            }, secondActionCompletion: {
                doubleAlertSheet.dismiss(animated: true, completion: secondCompletion)
            }, cancelCompletion: {
                doubleAlertSheet.dismiss(animated: true, completion: cacelcompletion)
            }
        )
        
        doubleAlertSheet.modalPresentationStyle = .custom
        doubleAlertSheet.transitioningDelegate = self
        present(doubleAlertSheet, animated: true)
    }
    
    func showTripleAlertSheet(
        firstActionText: String,
        secondActionText: String,
        thirdActionText: String,
        cancelText: String = "취소",
        firstCompletion: (() -> Void)? = nil,
        secondCompletion: (() -> Void)? = nil,
        thirdCompletion: (() -> Void)? = nil,
        cacelcompletion: (() -> Void)? = nil
    ) {
        let tripleAlertSheet = TripleAlertSheetController(
            firstActionText: firstActionText,
            secondActionText: secondActionText,
            thirdActionText: thirdActionText,
            cancelText: cancelText
        )
        tripleAlertSheet.addCompletionToButton(
            firstActionCompletion: {
                tripleAlertSheet.dismiss(animated: true, completion: firstCompletion)
            },
            secondActionCompletion: {
                tripleAlertSheet.dismiss(animated: true, completion: secondCompletion)
            },
            thirdActionCompletion: {
                tripleAlertSheet.dismiss(animated: true, completion: thirdCompletion)
            },
            cancelCompletion: {
                tripleAlertSheet.dismiss(animated: true, completion: cacelcompletion)
            }
        )
        
        tripleAlertSheet.modalPresentationStyle = .custom
        tripleAlertSheet.transitioningDelegate = self
        present(tripleAlertSheet, animated: true)
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        
        switch presented {
        case is SingleAlertSheetController:
            return AlertPC(
                presentedViewController: presented,
                presenting: presenting,
                maxHeight: SingleAlertSheetController.maxHeight
            )
        case is DoubleAlertSheetController:
            return AlertPC(
                presentedViewController: presented,
                presenting: presenting,
                maxHeight: DoubleAlertSheetController.maxHeight
            )
        case is TripleAlertSheetController:
            return AlertPC(
                presentedViewController: presented,
                presenting: presenting,
                maxHeight: TripleAlertSheetController.maxHeight
            )
        case is SelectAlignVC:
            return SelectAlignPC(
                presentedViewController: presented,
                presenting: presenting
            )
        case is WorksSelectAlignVC:
            return WorksSelectAlignPC(
                presentedViewController: presented,
                presenting: presenting
            )
        default:
            return UIPresentationController(presentedViewController: presented, presenting: presenting)
        }
    }
}
