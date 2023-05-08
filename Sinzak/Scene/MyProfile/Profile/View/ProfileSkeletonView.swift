//
//  ProfileSkeletonView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/08.
//

import UIKit
import SkeletonView

final class ProfileSkeletonView: SZView {
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.image = UIImage(named: "chat-thumbnail")
        $0.isSkeletonable = true
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "김신작김신작"
        $0.isSkeletonable = true
    }
    
    let schoolLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "홍익대학교 verifiedverifiedverifiedverified"
        $0.isSkeletonable = true
    }
    
    let followLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "32 팔로워 25 팔로잉25 팔로잉25 팔로잉25 팔로잉김신작김신작김신작김신작김신작"
        $0.isSkeletonable = true
    }
    
    let infoLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "자유롭게작업합니다최대글자수최대글자수최대글자수 최대글자수최대글자수최대글자수최대글자수최대글자수 자유롭게작업합니다최대글자수최대글자수최대글자수"
        $0.numberOfLines = 0
        $0.isSkeletonable = true
        $0.layer.cornerRadius = 12.0
        $0.clipsToBounds = true
    }
    
    let profileEditButton = UIButton().then {
        $0.setTitle(I18NStrings.editProfile, for: .normal)
        $0.setTitleColor(CustomColor.label, for: .normal)
        $0.titleLabel?.font = .body_M
        $0.layer.cornerRadius = 42.0 / 2
        $0.clipsToBounds = true
        $0.isSkeletonable = true
    }
    
    let scrapLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "김신작김신작김신작김신작김신작김신작김신작김신작김신작김신작"
        $0.isSkeletonable = true
    }
    
    let requestLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "김신작김신작김신작김신작김신작김신작김신작김신작김신작김신작"
        $0.isSkeletonable = true
    }

    let productsLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .body_B
        $0.textColor = CustomColor.label
        $0.text = "김신작김신작김신작김신작김신작김신작김신작김신작김신작김신작"
        $0.isSkeletonable = true
    }
    
    override func setView() {
        isSkeletonable = true
        
        addSubviews(
            profileImage,
            nameLabel,
            schoolLabel,
            followLabel,
            infoLabel,
            profileEditButton,
            scrapLabel,
            requestLabel,
            productsLabel
        )
    }
    
    override func setLayout() {
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(72.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(12.0)
            $0.centerX.equalToSuperview()
        }
        
        schoolLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(128.0)
            $0.centerX.equalToSuperview()
        }
        
        followLabel.snp.makeConstraints {
            $0.top.equalTo(schoolLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(112.0)
            $0.centerX.equalToSuperview()
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(followLabel.snp.bottom).offset(24.0)
            $0.leading.trailing.equalToSuperview().inset(36.0)
            $0.centerX.equalToSuperview()
        }
        
        profileEditButton.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(28.0)
            $0.width.equalTo(204.0)
            $0.height.equalTo(42.0)
            $0.centerX.equalToSuperview()
        }
        
        scrapLabel.snp.makeConstraints {
            $0.top.equalTo(profileEditButton.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(28.0)
        }
        
        requestLabel.snp.makeConstraints {
            $0.top.equalTo(scrapLabel.snp.bottom).offset(42.0)
            $0.leading.trailing.equalToSuperview().inset(28.0)
        }
        
        productsLabel.snp.makeConstraints {
            $0.top.equalTo(requestLabel.snp.bottom).offset(42.0)
            $0.leading.trailing.equalToSuperview().inset(28.0)
        }
    }
}
