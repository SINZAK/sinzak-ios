//
//  LikeView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/25.
//

import UIKit

final class LikeView: UIView {
    
    // MARK: - Properties
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.maximumSignificantDigits = 2
        
        return formatter
    }()

    var isSelected: Bool = false {
        willSet {
            if newValue {
                likeImageView.image = UIImage(named: "favorite-fill")!
                    .withTintColor(CustomColor.red, renderingMode: .alwaysOriginal)
            } else {
                likeImageView.image = UIImage(named: "favorite")!
                    .withTintColor(.white, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    var likesCount: Int = 0 {
        willSet {
            if newValue < 1000 {
                likeCountLabel.text = "\(newValue)"
            } else if newValue < 1000000 {
                let count: Double = Double(newValue) / 1000
                likeCountLabel.text = newValue < 10000 ?
                (numberFormatter.string(from: count as NSNumber) ?? "") + "K" :
                "\(Int(count))"+"K"
            } else {
                let count: Double = Double(newValue) / 1000000
                likeCountLabel.text = newValue < 10000000 ?
                (numberFormatter.string(from: count as NSNumber) ?? "") + "M" :
                "\(Int(count))"+"M"
            }
        }
    }
    
    // MARK: - UI
    
    let likeCountLabel = UILabel().then {
        $0.text = "1.3K"
        $0.font = .buttonText_R
        $0.textAlignment = .center
        $0.textColor = CustomColor.white
    }
    
    let likeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        backgroundColor = CustomColor.onlyGray80.withAlphaComponent(0.4)
        
        addSubviews(likeImageView, likeCountLabel)
        
        likeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(1.5)
            $0.width.height.equalTo(16.0)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(likeImageView.snp.bottom).offset(-1)
        }
    }
}
