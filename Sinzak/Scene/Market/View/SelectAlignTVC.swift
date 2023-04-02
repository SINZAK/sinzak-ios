//
//  SelectAlignTVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/02.
//

import UIKit

final class SelectAlignTVC: UITableViewCell {
    
    // MARK: - Property
    
    var alignOption: AlignOption?
    
    // MARK: - UI
    
    private let alignLabel: UILabel = {
        let label = UILabel()
        label.font = .body_M
        
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        let infoIcon = UIImage(named: "info")?
            .withTintColor(
                CustomColor.gray80!,
                renderingMode: .alwaysOriginal
            )
        button.setImage(infoIcon, for: .normal)
        button.isHidden = true
        
        return button
    }()
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        let checkIcon = UIImage(named: "checkmark")?
            .withTintColor(
                CustomColor.label!,
                renderingMode: .alwaysOriginal
            )
        imageView.image = checkIcon
        imageView.isHidden = true
        
        return imageView
    }()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.gray60
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cofigureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with alignOption: AlignOption) {
        self.alignOption = alignOption
        alignLabel.text = alignOption.text
        if alignOption == .recommend || alignOption == .popular {
            infoButton.isHidden = false
        }
        if alignOption == .high {
            separateView.isHidden = true
        }
    }
}

// MARK: - Private Method

private extension SelectAlignTVC {

    func cofigureLayout() {
        self.backgroundColor = CustomColor.background
        
        [
            alignLabel,
            infoButton,
            checkImageView,
            separateView
        ].forEach { addSubviews($0) }
        
        alignLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.centerY.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints {
            $0.leading.equalTo(alignLabel.snp.trailing)
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.0)
            $0.centerY.equalToSuperview()
        }
        
        separateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
