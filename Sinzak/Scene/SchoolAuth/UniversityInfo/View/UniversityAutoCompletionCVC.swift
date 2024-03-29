//
//  UniversityAutoCompletionCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/26.
//

import UIKit
import SnapKit
import Then

final class UniversityAutoCompletionCVC: UICollectionViewCell {
    // MARK: - Properties
    let textLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.label
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Design Helper
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(textLabel)
    }
    func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }

    override func prepareForReuse() {
        textLabel.text = ""
        textLabel.textColor = CustomColor.label
    }
}
