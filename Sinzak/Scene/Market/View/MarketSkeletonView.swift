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
        layout.estimatedItemSize = CGSize(width: (width - 48.0) / 2, height: 264)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16.0, bottom: 0, right: 16.0)
        
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
        self.backgroundColor = CustomColor.background
        self.isSkeletonable = true
        addSubview(productCollectionView)
    }
    
    override func setLayout() {
        productCollectionView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
