//
//  FollowButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/08/10.
//

import UIKit
import RxSwift

final class FollowButton: UIButton {
    
    var isFollowing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = .body_M
        setTitle("팔로우", for: .normal)
        setTitleColor(CustomColor.red, for: .normal)
        layer.cornerRadius = 21
        layer.borderWidth = 1.5
        layer.borderColor = CustomColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Reactive where Base: FollowButton {
    var isFollowing: Binder<Bool> {
        return Binder(self.base) { button, bool in
            switch bool {
            case true:
                button.setTitle("팔로잉", for: .normal)
                button.backgroundColor = CustomColor.red
                button.setTitleColor(CustomColor.white, for: .normal)
            case false:
                button.setTitle("팔로우", for: .normal)
                button.backgroundColor = .clear
                button.setTitleColor(CustomColor.red, for: .normal)
            }
            button.isFollowing = bool
        }
    }
}
