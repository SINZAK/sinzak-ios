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
    
    let label1: UILabel = {
        let label = UILabel()
        label.font = .subtitle_B
        label.text = "최신 작품작품작품"
        label.textColor = .clear
        label.isSkeletonable = true
        
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.font = .subtitle_B
        label.text = "최신 작품작품작품"
        label.textColor = .clear
        label.isSkeletonable = true
        
        return label
    }()
    
    lazy var flowLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 164.0, height: 240)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        layout.minimumLineSpacing = 40.0
        
        return layout
    }()
    
    lazy var collectionView1: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
                
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )

        return collectionView
    }()
    
    lazy var collectionView2: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
                
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        collectionView.register(
            ArtCVC.self,
            forCellWithReuseIdentifier: ArtCVC.identifier
        )

        return collectionView
    }()

    // MARK: - Design Helpers
    override func setView() {
        self.isHidden = true
        self.isSkeletonable = true
        
        addSubviews(
            imageView,
            label1,
            collectionView1,
            label2,
            collectionView2
        )
    }
    override func setLayout() {

        imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(40.0)
            $0.height.equalTo(imageView.snp.width).multipliedBy(0.42)
        }
        
        label1.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(imageView.snp.bottom).offset(32.0)
        }

        collectionView1.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(label1.snp.bottom).offset(28.0)
            $0.height.equalTo(248)
        }
        
        label2.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(collectionView1.snp.bottom).offset(28.0)
        }
        
        collectionView2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(label2.snp.bottom).offset(28.0)
            $0.height.equalTo(248)
        }
    }
}
