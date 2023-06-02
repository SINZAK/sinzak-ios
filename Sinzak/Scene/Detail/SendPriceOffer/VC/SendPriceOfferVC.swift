//
//  SendPriceOfferVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

final class SendPriceOfferVC: SZVC {
    // MARK: - Properties
    let id: Int
    let type: DetailType
    let maxPrice: BehaviorRelay<Int>
    let mainView = SendPriceOfferView()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Init
    init(id: Int, maxPrice: BehaviorRelay<Int>, type: DetailType) {
        self.id = id
        self.maxPrice = maxPrice
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mainView.priceTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Helpers
    override func configure() {
        bind()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "가격 제안하기"
    }
    
    private func bind() {
        
        maxPrice
            .asDriver()
            .map { maxPrice in
                var maxPrice = maxPrice.toMoenyFormat()
                _ = maxPrice.popLast()
                return maxPrice
            }
            .drive(mainView.priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(
                with: self,
                onNext: { owner, keyboardVisibleHeight in
                    if keyboardVisibleHeight > 0 {
                        owner.mainView.suggestButton.snp.updateConstraints {
                            $0.bottom.equalToSuperview().inset(keyboardVisibleHeight + 16.0)
                        }
                        owner.view.layoutIfNeeded()
                    } else {
                        owner.mainView.suggestButton.snp.updateConstraints {
                            $0.bottom.equalToSuperview().inset(24.0)
                        }
                        owner.view.layoutIfNeeded()
                    }
                })
            .disposed(by: disposeBag)
        
        let textFieldInput = mainView.priceTextField.rx.text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
        
        textFieldInput
            .map { !$0.isEmpty }
            .drive(mainView.suggestButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        mainView.suggestButton.rx.tap
            .withUnretained(self) 
            .subscribe(onNext: { owner, _ in
                guard let price = Int(owner.mainView.priceTextField.text ?? "") else {
                    owner.showSinglePopUpAlert(message: "숫자만 입력 가능합니다.")
                    return
                }
                
                var suggestPrice: Single<Bool>
                
                switch owner.type {
                case .purchase:
                    suggestPrice = ProductsManager.shared.suggestPrice(id: owner.id, price: price)
                case .request:
                    suggestPrice = WorksManager.shared.suggestPrice(id: owner.id, price: price)
                }
                
                suggestPrice
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { _ in
                            owner.showLoading()
                            owner.showSinglePopUpAlert(message: "제안 완료", actionCompletion: {
                                if owner.maxPrice.value < price {
                                    owner.maxPrice.accept(price)
                                }
                                owner.navigationController?.popViewController(animated: true)
                            })
                        },
                        onFailure: { error in
                            owner.simpleErrorHandler.accept(error)
                        },
                        onDisposed: {
                            owner.hideLoading()
                        })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}
