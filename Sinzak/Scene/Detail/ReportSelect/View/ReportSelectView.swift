//
//  ReportSelectView.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit

final class ReportSelectView: SZView {
    
    // MARK: - Property
    
    let name: String
    
    // MARK: - UI
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.label
        label.font = .body_B
        label.text =
            """
            '\(name)'
            사용자를 신고하는 이유를 선택해주세요.
            """
        label.numberOfLines = 2
        label.addInterlineSpacing()

        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(
            SelectTableViewCell.self,
            forCellReuseIdentifier: SelectTableViewCell.identifier
        )
        tableView.isScrollEnabled = false
        tableView.rowHeight = 66.0
        tableView.backgroundColor = CustomColor.background
        
        return tableView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.gray60
        
        return view
    }()
    
    init(name: String) {
        self.name = name
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setView() {
        addSubviews(
            infoLabel,
            tableView,
            separator
        )
    }
    
    override func setLayout() {
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24.0)
            $0.leading.equalToSuperview().inset(32.0)
        }
        
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(tableView.snp.top)
            $0.height.equalTo(0.5)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
