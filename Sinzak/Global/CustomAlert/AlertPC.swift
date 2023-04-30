//
//  AlertPC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit

final class AlertPC: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    var maxHeight: CGFloat?
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissController)
        )
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    convenience init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        maxHeight: CGFloat
    ) {
        self.init(presentedViewController: presentedViewController, presenting: presenting)
        self.maxHeight = maxHeight
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(
            origin: CGPoint(
                x: 0,
                y: containerView!.frame.height - (maxHeight ?? 0.0)
            ),
            size: CGSize(
                width: containerView!.frame.width,
                height: maxHeight ?? 0.0
            )
        )
    }
    
    // 프레임 설정
    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.blurEffectView.alpha = 0.5
            }, completion: { _ in })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.blurEffectView.alpha = 0
            }, completion: {[ weak self] _ in
                self?.blurEffectView.removeFromSuperview()
            })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
