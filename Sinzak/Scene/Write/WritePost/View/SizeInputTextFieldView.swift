//
//  SizeInputTextFieldView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/21.
//

import UIKit

enum SizeType {
    case width
    case vertical
    case height
    
    var type: String {
        switch self {
        case .width:        return "가로"
        case .vertical:     return "세로"
        case .height:       return "높이"
        }
    }
}

final class SizeInputTextFieldView: SZView {
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .caption_B
        label.textColor = CustomColor.gray80
        
        return label
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = CustomColor.label
        textField.tintColor = CustomColor.red
        textField.font = .subtitle_B
        textField.textAlignment = .center
        textField.layer.cornerRadius = 48.0 / 2
        textField.backgroundColor = CustomColor.gray10
        textField.clipsToBounds = true
        
        return textField
    }()
    
    let unitLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray80
        label.font = .body_B
        label.text = "cm"
        
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        stackView.alignment = .center
        
        return stackView
    }()
    
    init(sizeType: SizeType) {
        super.init(frame: .zero)
        
        typeLabel.text = sizeType.type
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SizeInputTextFieldView {
    
    func configureLayout() {
            
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubviews(
            typeLabel,
            inputTextField,
            unitLabel
        )
        
        containerStackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        inputTextField.snp.makeConstraints {
            $0.height.equalTo(48.0)
            $0.width.equalTo(200.0)
        }
    }
}
