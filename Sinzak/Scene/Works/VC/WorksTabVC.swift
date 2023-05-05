//
//  WorksTabVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import UIKit
import RxSwift
import RxCocoa
import Tabman
import Pageboy

final class WorksTabVC: TabmanViewController {
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let worksMode: WorksMode
    
    var defaultPage: Int = 0
    
    let alignInfoRelay: BehaviorRelay<(
        isEmployment: Bool,
        align: AlignOption
    )> = .init(value: (true, .recommend))
    
    let searchButtonTapped: BehaviorRelay<(isEmployment: Bool, text: String)> = .init(value: (isEmployment: true, text: ""))
    let worksCollectionViewBeginDragging: PublishRelay<Bool> = .init()
    
    // 페이징할 VC
    private lazy var employmentVM = DefaultWorksVM(
        isEmployment: true,
        alignInfoRelay: alignInfoRelay,
        searchButtonTapped: searchButtonTapped
    )
    private lazy var workVM = DefaultWorksVM(
        isEmployment: false,
        alignInfoRelay: alignInfoRelay,
        searchButtonTapped: searchButtonTapped
    )
    
    private lazy var viewControllers = worksMode == .watch ?
    [
        WorksVC(viewModel: employmentVM, mode: worksMode),
        WorksVC(viewModel: workVM, mode: worksMode)
    ] :
    [
        WorksVC(
            viewModel: employmentVM,
            mode: worksMode,
            worksCollectionViewBeginDragging: worksCollectionViewBeginDragging
        ),
        WorksVC(
            viewModel: workVM,
            mode: worksMode,
            worksCollectionViewBeginDragging: worksCollectionViewBeginDragging
        )
    ]
     
    init(worksMode: WorksMode) {
        self.worksMode = worksMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 탭바 숨김처리
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Helpers
    func configure() {
        view.backgroundColor = CustomColor.white
        // 탭바 Datasource
        self.dataSource = self
        // 탭바 생성
        let bar = TMBar.ButtonBar()
        settingTabBar(for: bar)
        addBar(bar, dataSource: self, at: .top)
                
    }
    /// 네비게이션 바 설정
    func setNavigationBar() {
        // 색상 설정
        navigationController?.navigationBar.tintColor = CustomColor.label
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.body_B,
            NSAttributedString.Key.foregroundColor: CustomColor.label
        ]
        // 루트뷰가 아닐 경우 백버튼
        if self != navigationController?.viewControllers.first {
            let customBackButton = UIBarButtonItem(
                image: UIImage(named: "back"),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped) )
            navigationItem.leftBarButtonItem = customBackButton
        }
        navigationItem.title = "의뢰"

    }
    // MARK: - Actions
    /// 네비게이션  뒤로가기 버튼
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// 탭바 관련 설정
extension WorksTabVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        // Tab Title
        switch index {
        case 0:
            return TMBarItem(title: "의뢰해요" )
        case 1:
            return TMBarItem(title: "작업해요")
        default:
            return TMBarItem(title: "")
        }
    }
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        // 페이지 갯수
        return 2
    }
    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[index]
    }
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: defaultPage)
    }
}
extension WorksTabVC {
    func settingTabBar (for bar: TMBar.ButtonBar) {
        view.backgroundColor = CustomColor.background
                                
        bar.layout.transitionStyle = .progressive
        bar.layout.alignment = worksMode == .watch ? .leading : .centerDistributed
        bar.layout.contentInset = UIEdgeInsets(
            top: 0,
            left: worksMode == .watch ? 24.0 : 0,
            bottom: 0,
            right: 0
        )
        // 간격
        bar.layout.interButtonSpacing = 12.0
        bar.backgroundView.style = .clear
        bar.backgroundColor = CustomColor.background
        // 바버튼 색상, 폰트
        bar.buttons.customize { (button) in
            button.tintColor = CustomColor.gray60
            button.selectedTintColor = CustomColor.label
            button.font = .body_B
            button.selectedFont = .body_B
        }
        // 인디케이터 설정
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = CustomColor.label
    }
}
