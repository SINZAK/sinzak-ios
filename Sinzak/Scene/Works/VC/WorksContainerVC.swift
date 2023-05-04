//
//  WorksContainerVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WorksContainerVC: SZVC {
    
    let disposebag = DisposeBag()
    
    private let worksTabVC = WorksTabVC()
    
    private let alignButton = UIButton().then {
        $0.setImage(UIImage(named: "align"), for: .normal)
        $0.setTitle("신작추천순", for: .normal)
        $0.titleLabel?.font = .caption_B
        $0.setTitleColor(CustomColor.gray80, for: .normal)
        $0.tintColor = CustomColor.gray80
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
        
        navigationItem.title = "의뢰"
    }
    
    override func configure() {
        super.configure()
        
        addChild(worksTabVC)
        view.addSubview(worksTabVC.view)
        
        worksTabVC.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(alignButton)
        view.bringSubviewToFront(alignButton)
        
        alignButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }

        bind()
    }
    
    private func bind() {
        worksTabVC.alignInfoRelay
            .map { $0.align.text }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(alignButton.rx.title(for: .normal))
            .disposed(by: disposebag)
        
//            .subscribe(
//                with: self,
//                onNext: { owner, zip in
//                    let alignOption = zip.align
//                    owner.alignButton.setTitle(alignOption.text, for: .normal)
//                })
//            .disposed(by: disposebag)
        
        alignButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let vc = WorksSelectAlignVC(with: owner.worksTabVC.alignInfoRelay)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                owner.present(vc, animated: true)
            })
            .disposed(by: disposebag)
    }
}
