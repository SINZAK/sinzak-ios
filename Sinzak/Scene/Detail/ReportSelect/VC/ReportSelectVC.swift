//
//  ReportSelectVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ReportSelectVC: SZVC {
    
    // MARK: - Propertied
    
    typealias ReportSection = SectionModel<Void, String>
    
    private let mainView: ReportSelectView

    private let sections = [
        ReportSection(
            model: Void(),
            items: [
                "전문 판매업자 같아요",
                "비매너 사용자에요",
                "성희롱을 해요",
                "거래 / 환불 분쟁 신고",
                "사기 당했어요",
                "다른 문제가 있어요"
            ]
        )
    ]
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(userName: String) {
        self.mainView = ReportSelectView(name: userName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = "사용자 신고"
    }
    
    override func configure() {
        bind()
    }
    
    private func bind() {
        Observable.just(sections)
            .bind(to: mainView.tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.mainView.tableView.deselectRow(at: item, animated: true)
                
//                let name = sections[0].items[0]
//                Log.debug(name)
            })
            .disposed(by: disposeBag)
    }
}

private extension ReportSelectVC {
    func getDataSource() -> RxTableViewSectionedReloadDataSource<ReportSection> {
        return RxTableViewSectionedReloadDataSource(configureCell: { _, tableView, indexPath, item in
                        
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SelectTableViewCell.identifier,
                for: indexPath
            ) as? SelectTableViewCell else { return UITableViewCell() }
            cell.setTitle(item)
            
            return cell
        })
    }
}
