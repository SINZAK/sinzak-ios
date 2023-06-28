//
//  MarketSkeletonView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/08.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

final class MarketSkeletonView: SZView {
    
    // MARK: - UI
    
    private lazy var productFlowLayout: UICollectionViewLayout = {
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let insets = 16.0 * 3
        let heightOfImageView = (width-insets) / 2
        let heightOfLabels = 88.0
        layout.estimatedItemSize = CGSize(
            width: (width - insets) / 2,
            height: heightOfImageView + heightOfLabels
        )
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0, right: 16.0)
        
        return layout
    }()
    
    lazy var productCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: productFlowLayout
    ).then {
        $0.backgroundColor = CustomColor.background
        $0.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        $0.allowsMultipleSelection = true
        $0.backgroundColor = .clear
        $0.isSkeletonable = true
    }
    
    override func setView() {
        self.backgroundColor = .clear
        productCollectionView.backgroundColor = CustomColor.background
        self.isSkeletonable = true
        addSubview(productCollectionView)
    }
    
    override func setLayout() {
        productCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(96.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
