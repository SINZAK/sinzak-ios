//
//  WriteCategoryHeader.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import UIKit
import SnapKit
import Then

final class WriteCategoryHeader: UICollectionReusableView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.gray80
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
    // MARK: - Helper
    func update(kind: WriteCategoryHeaderKind) {
        titleLabel.text = "˙ " + kind.text
    }
    // MARK: - Design Helpers
    func setupUI() {
        addSubviews(
            titleLabel
        )
    }
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
