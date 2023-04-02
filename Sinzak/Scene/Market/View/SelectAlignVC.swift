//
//  SelectAlignVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/02.
//

import UIKit

final class SelectAlignVC: SZVC {
    
    // MARK: - Constant
    
    // MARK: - Property
    
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    // MARK: - UI
    
    let sliderIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.label
        view.layer.cornerRadius = 3
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setGesture()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Init
    
//    init(_ reactor: TaskEditViewReactor) {
//        super.init()
//
//        self.reactor = reactor
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}

// MARK: - Private

private extension SelectAlignVC {
    func setupLayout() {
    
        [
            sliderIndicator
        ].forEach { view.addSubview($0) }
        
        sliderIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(2.5)
            $0.width.equalTo(50.0)
            $0.height.equalTo(6)
        }
    }
    
    func setGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureRecognizerAction)
        )
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Selector
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
