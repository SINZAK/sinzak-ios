//
//  ChatListView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class ChatListView: SZView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    
    let noContentsLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅 목록이 없어요."
        label.textColor = CustomColor.gray60
        label.font = .body_R
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            collectionView,
            noContentsLabel
        )
    }
    override func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        noContentsLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(152.0)
            $0.centerX.equalToSuperview()
        }
    }
}
