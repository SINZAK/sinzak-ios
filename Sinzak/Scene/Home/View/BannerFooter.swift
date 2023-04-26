//
//  BannerFooter.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/26.
//

import UIKit
import RxSwift
import RxRelay

final class BannerFooter: UICollectionReusableView {
    
    // MARK: - Properties
    
    var bannerIndex: BehaviorRelay<Int>?
    var bannerTotalIndex: BehaviorRelay<Int>?
    let disposeBag = DisposeBag()
    
    // MARK: - UI
    
    let pageControll: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 2
        pageControl.numberOfPages = 3
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = CustomColor.red
        pageControl.pageIndicatorTintColor = CustomColor.gray40
        
        return pageControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configFooter(
        _ bannerIndex: BehaviorRelay<Int>,
        _ bannerTotalIndex: BehaviorRelay<Int>
    ) {
        self.bannerIndex = bannerIndex
        self.bannerTotalIndex = bannerTotalIndex
        
        bind()
    }
    
    private func setupUI() {
       addSubview(pageControll)
    }
    
    private func setConstraints() {
        pageControll.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32.0)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        
        bannerTotalIndex?
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: 0)
            .drive(pageControll.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        bannerIndex?
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: 0)
            .drive(pageControll.rx.currentPage)
            .disposed(by: disposeBag)
    }
}
