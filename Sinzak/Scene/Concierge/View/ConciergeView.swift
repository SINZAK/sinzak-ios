//
//  ConciergeView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit
import SnapKit
import Then

final class ConciergeView: UIView {
    // MARK: - Properties
    private let logoView = UIImageView().then {
        $0.image = UIImage(named: "splash_logo")
        $0.contentMode = .scaleAspectFit
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions, Helpers
    func setView() {
        backgroundColor = .systemBackground
        addSubview(logoView)
    }
    func setConstraints() {
        logoView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(logoView.snp.width).multipliedBy(0.7)
            make.centerX.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
}
