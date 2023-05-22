//
//  WritePostView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class WritePostView: SZView {
    // MARK: - Properties
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = CustomColor.background
        
        return scrollView
    }()
    
    let contentView: SZView = {
        let view = SZView()
        
        return view
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.alwaysBounceVertical = false
        $0.backgroundColor = .clear
        $0.register(
            SelectPhotoCVC.self,
            forCellWithReuseIdentifier: SelectPhotoCVC.identifier
        )
        $0.register(
            SelectedPhotoCVC.self,
            forCellWithReuseIdentifier: SelectedPhotoCVC.identifier
        )
    }
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.tintColor = CustomColor.red
        textView.textColor = CustomColor.label
        textView.font = .body_B
        textView.layer.cornerRadius = 30.0
        textView.backgroundColor = CustomColor.gray10
        textView.isScrollEnabled = false
        textView.textContainerInset = .init(
            top: 30.0 - 8.0,
            left: 20.0,
            bottom: 60.0 - (30.0 - 8.0) - 16.0,
            right: 20.0
        )
        
        return textView
    }()
    let titlePlaceholder: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray60
        label.font = .body_R
        label.text = "작품 제목"
        
        return label
    }()
    
    let priceTextField: SZNumberTextField = {
        let textField = SZNumberTextField(insets: .init(
            top: 0,
            left: 28.0,
            bottom: 0,
            right: 0
        ))
        textField.layer.cornerRadius = 44.0 / 2
        textField.clipsToBounds = true
        textField.keyboardType = .numberPad
        textField.attributedPlaceholder = NSAttributedString(
            string: "가격",
            attributes: [
                .foregroundColor: CustomColor.gray60,
                .font: UIFont.body_R
            ]
        )
        
        return textField
    }()
    let priceUnitLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray60
        label.font = .body_R
        label.text = "원"
        
        return label
    }()
    let isPossibleSuggestButton: CircleCheckButton = {
        let button = CircleCheckButton()
        button.isSelected = false
        button.setTitle("가격제안 받기", for: .normal)
        button.setTitleColor(CustomColor.label, for: .normal)
        button.titleLabel?.font = .caption_R
        button.titleEdgeInsets = UIEdgeInsets(
            top: 2.0,
            left: 2.0,
            bottom: 0,
            right: -2.0
        )
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.tintColor = CustomColor.red
        textView.layer.cornerRadius = 24.0
        textView.backgroundColor = CustomColor.gray10
        textView.isScrollEnabled = false
        textView.textContainerInset = .init(
            top: 24.0,
            left: 24.0,
            bottom: 24.0,
            right: 24.0
        )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        textView.typingAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.body_R,
            NSAttributedString.Key.foregroundColor: CustomColor.label
        ]
        
        return textView
    }()
    let bodyPlaceholder: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray60
        label.font = .body_R
        label.text = "작품 의도, 작업 기간, 재료, 거래 방법 등을 자유롭게 표현해보세요."
        label.numberOfLines = 0
        label.addInterlineSpacing()
        
        return label
    }()
    
    let inputSizeView: SZView = {
        let view = SZView()
        
        return view
    }()
    
    let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "˙ " + "작품 사이즈 (선택)"
        label.font = .body_R
        label.textColor = CustomColor.gray80
        
        return label
    }()
    
    let widthSizeInputTextFieldView = SizeInputTextFieldView(sizeType: .width)
    let verticalSizeInputTextFieldView = SizeInputTextFieldView(sizeType: .vertical)
    let heightSizeInputTextFieldView = SizeInputTextFieldView(sizeType: .height)
    
    let sizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.alignment = .center
                
        return stackView
    }()

    // MARK: - Design Helpers
    override func setView() {
        
        scrollView.addSubviews(
            contentView
        )
        
        contentView.addSubviews(
            collectionView,
            titleTextView, titlePlaceholder,
            priceTextField, priceUnitLabel, isPossibleSuggestButton,
            bodyTextView, bodyPlaceholder,
            sizeTitleLabel,
            sizeStackView
        )
        
        sizeStackView.addArrangedSubviews(
            widthSizeInputTextFieldView,
            verticalSizeInputTextFieldView,
            heightSizeInputTextFieldView
        )
        
        addSubviews(
            scrollView
        )
    }
    override func setLayout() {
                
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(sizeStackView).offset(60.0)
        }
        
        collectionView.collectionViewLayout = setLayout()
    
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(contentView).offset(16.0)
            make.height.equalTo(132.0)
        }
        
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.greaterThanOrEqualTo(60.0)
        }
        titlePlaceholder.snp.makeConstraints {
            $0.top.equalTo(titleTextView).offset(30.0 - 8.0)
            $0.leading.equalTo(titleTextView).offset(20.0 + 4.0)
        }
        
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(12.0)
            $0.leading.equalTo(titleTextView)
            $0.height.equalTo(44.0)
            $0.width.equalTo(184.0)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.leading.equalTo(priceTextField.snp.trailing).offset(16.0)
            $0.centerY.equalTo(priceTextField)
        }
        isPossibleSuggestButton.snp.makeConstraints {
            $0.leading.equalTo(priceUnitLabel.snp.trailing).offset(16.0)
            $0.height.equalTo(24.0)
            $0.width.equalTo(108.0)
            $0.centerY.equalTo(priceTextField)
        }
        
        bodyTextView.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(titleTextView)
            $0.height.greaterThanOrEqualTo(184.0)
        }
        bodyPlaceholder.snp.makeConstraints {
            $0.top.equalTo(bodyTextView).offset(25.0)
            $0.leading.equalTo(bodyTextView).offset(24.0 + 4.0)
            $0.trailing.equalTo(bodyTextView).offset(-24.0)
        }
        
        sizeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bodyTextView.snp.bottom).offset(24.0)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        sizeStackView.snp.makeConstraints {
            $0.top.equalTo(sizeTitleLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.lessThanOrEqualTo(16.0 + 12.0 * 3 + 48.0 * 3)
        }
        [
            widthSizeInputTextFieldView,
            verticalSizeInputTextFieldView,
            heightSizeInputTextFieldView
        ].forEach { view in
            view.snp.makeConstraints {
                $0.height.equalTo(48.0)
            }
        }
    }
}

// 컴포지셔널 레이아웃
private extension WritePostView {
    /// 컴포지셔널 레이아웃 세팅
    func setLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(72.0),
                heightDimension: .estimated(100.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.contentInsets.bottom = 4.0
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2.0),
                heightDimension: .estimated(132.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            section.interGroupSpacing = 0
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
}

// MARK: - Update Layout

extension WritePostView {
    
    func remakeKeyboardShowLayout() {
        contentView.snp.remakeConstraints { [weak self] in
            let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            $0.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(sizeStackView).offset(60.0 + sizeStackView.frame.height + bottom)
            self?.sizeInputScrollLayout()
        }
    }
    
    func remakeKeyboardNotShowLayout() {
        contentView.snp.remakeConstraints {
            $0.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(sizeStackView).offset(60.0)
        }
    }
    
    func sizeInputScrollLayout() {
        if widthSizeInputTextFieldView.inputTextField.isEditing ||
            verticalSizeInputTextFieldView.inputTextField.isEditing ||
            heightSizeInputTextFieldView.inputTextField.isEditing {
                        
            scrollView.scroll(to: .bottom, animated: true)
        }
    }
}
