//
//  UniversityInfoVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/29.
//

import UIKit
import RxSwift

final class UniversityInfoVC: SZVC {
    // MARK: - Properties
    private let mainView = UniversityInfoView()
    let viewModel = SchoolAuthViewModel()
    var schoolList: [String] = []
    var filteredData: [String] = []
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolList = SchoolList.loadJson()!.school.flatMap { $0.koreanName }
    }
    // MARK: - Actions
    // MARK: - Helpers
    override func configure() {
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.leftBarButtonItem = nil // 이미 가입이 끝난 상황이라 뒤로 돌아가면 안됨
    }
    func bind() {
        let input = SchoolAuthViewModel.Input(queryText: mainView.searchTextField.rx.text, nextButtonTap: mainView.nextButton.rx.tap, notStudentButtonTap: mainView.notStudentButton.rx.tap)
        let output = viewModel.transform(input: input)
        output.nextButtonTap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let vc = StudentAuthVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        output.notStudentButtonTap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let vc = WelcomeVC()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        output.queryText
            .bind { [weak self] query in
                guard let self = self else { return }
                if query.count > 0 {
                    self.filteredData.removeAll(keepingCapacity: false)
                    let searchPredicate = NSPredicate(format: "SELF CONTAINS %@", query)
                    let array = (self.schoolList as NSArray).filtered(using: searchPredicate)
                    self.filteredData = array as! [String]
                    print(self.filteredData)
                    /// 이제 검색목록을 뷰에 뿌리기
                } else {
                    self.filteredData.removeAll(keepingCapacity: false)
                }
            }.disposed(by: viewModel.disposeBag)
    }
}
