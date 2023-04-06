//
//  ConciergeView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit
import SwiftUI
import SnapKit
import Then
import Lottie

final class ConciergeView: UIView {
    // MARK: - Properties
    
    lazy var logoView: AnimationView = {
        let currentScheme = UITraitCollection.current.userInterfaceStyle
        
        func schemeTransform(userInterfaceStyle: UIUserInterfaceStyle) -> ColorScheme {
            if userInterfaceStyle == .light {
                return .light
            } else if userInterfaceStyle == .dark {
                return .dark
            }
            return .light
        }
        let scheme = schemeTransform(userInterfaceStyle: currentScheme)
        
        let animationView = scheme == .light ? AnimationView(name: "sinzak_splash_animation_light") : AnimationView(name: "sinzak_splash_animation_dark")
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        return animationView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions, Helpers
    func setView() {
        backgroundColor = CustomColor.background
        addSubview(logoView)
    }
    func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(logoView.snp.width).multipliedBy(0.7)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide).multipliedBy(0.8)
        }
    }
}
