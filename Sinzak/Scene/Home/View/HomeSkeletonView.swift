//
//  HomeSkeletonView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/20.
//

import UIKit

class HomeSkeletonView: SZView {
    // MARK: - Properties
    
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.isSkeletonable = true
    }
    
    lazy var productFlowLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.estimatedItemSize = CGSize(width: 165, height: 240)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
//        layout.minimumLineSpacing = 16.0
//        layout.minimumInteritemSpacing = 28.0
        //            layout.headerReferenceSize = CGSize(width: 10, height: 40)
        //            layout.headerReferenceSize = CGSize(width: width, height: 40)
        //            layout.minimumLineSpacing =
        
        return layout
    }()
    
    lazy var homeProductSekeletoneCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: productFlowLayout
        )
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )
        collectionView.register(
            HomeHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeader.identifier
        )

        return collectionView
    }()

    // MARK: - Design Helpers
    override func setView() {
        self.isHidden = true
        self.isSkeletonable = true
        addSubviews(
            imageView,
            homeProductSekeletoneCollectionView
        )
    }
    override func setLayout() {

        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(40.0)
            $0.height.equalTo(imageView.snp.width).multipliedBy(0.42)
        }
        
        homeProductSekeletoneCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32.0)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
}
