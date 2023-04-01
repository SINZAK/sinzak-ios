//
//  MarketView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/24.
//

import UIKit
import SnapKit
import Then

final class MarketView: SZView {
    // MARK: - Properties
    lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        
    }
    
    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
    }
    
    let viewOptionButton = UIButton().then {
        $0.setImage(UIImage(named: "radiobtn-unchecked"), for: .normal)
        $0.setTitle("판매중 작품만 보기", for: .normal)
        $0.titleLabel?.font = .caption_M
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
    }
    
    let alignButton = UIButton().then {
        $0.setImage(UIImage(named: "align"), for: .normal)
        $0.setTitle("신작추천순", for: .normal)
        $0.titleLabel?.font = .caption_B
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
    }
    
    let writeButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 31
        $0.backgroundColor = CustomColor.red
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            categoryCollectionView,
            viewOptionButton, alignButton,
            productCollectionView, writeButton
        )
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        productCollectionView.refreshControl = refreshControl
    }
    
    override func setLayout() {
        
        categoryCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(56.0)
        }
        
        viewOptionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18.0)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8.0)
            make.height.equalTo(22)
        }
    
        alignButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18.0)
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8.0)
            make.height.equalTo(22)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(alignButton.snp.bottom).offset(8.0)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints { make in
            make.width.height.equalTo(62)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(7)
            make.trailing.equalToSuperview().inset(11)
        }
    }
}
