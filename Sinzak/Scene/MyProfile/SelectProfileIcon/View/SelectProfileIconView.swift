//
//  SelectProfileIconView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/11.
//

import UIKit
import SnapKit
import Then

final class SelectProfileIconView: SZView {
    // MARK: - Properties
    
    let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = CustomColor.gray60.cgColor
        imageView.layer.cornerRadius = 24.0
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let selectInAlbumButton: UIButton = {
        let button = UIButton()
        button.setTitle("앨범에서 선택하기", for: .normal)
        button.setTitleColor(CustomColor.purple, for: .normal)
        button.titleLabel?.font = .caption_M
        
        return button
    }()
    
    let selectCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = CustomColor.background
        collectionView.register(
            SelectIconCVC.self,
            forCellWithReuseIdentifier: SelectIconCVC.identifier
        )
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
   
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            selectedImageView,
            selectInAlbumButton,
            selectCollectionView
        )
    }
    
    override func setLayout() {
        selectCollectionView.collectionViewLayout = configSelectCollectionViewLayout()
        
        selectedImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(8.0)
            $0.width.height.equalTo(72.0)
        }
        
        selectInAlbumButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(selectedImageView.snp.bottom).offset(16.0)
            $0.height.equalTo(24.0)
        }
                
        selectCollectionView.snp.makeConstraints {
            let width = (UIScreen.main.bounds.width - 24 - 12 - 12 - 24) / 3
            
            $0.leading.trailing.equalToSuperview()
            $0.top.greaterThanOrEqualTo(selectInAlbumButton.snp.bottom).offset(24.0)
            $0.height.equalTo(width * 4 + 12 * 4)
            $0.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(-60.0)
                .priority(.high)
        }
    }
}

private extension SelectProfileIconView {
    
    func configSelectCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
        
            let width = (UIScreen.main.bounds.width - 24 - 12 - 12 - 24) / 3
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(width),
                heightDimension: .absolute(width)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(width)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            group.interItemSpacing = .fixed(12.0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 24.0,
                bottom: 0,
                trailing: 24.0
            )
            
            section.interGroupSpacing = 12.0
            
            return section
        }
    }
}
