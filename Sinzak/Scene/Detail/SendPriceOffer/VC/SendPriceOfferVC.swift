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
    let mainView = SendPriceOfferView()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    
    // MARK: - Init
    init(id: Int, topPrice: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        
        var text = topPrice.toMoenyFormat()
        _ = text.removeLast()
        self.mainView.priceLabel.text = text
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
        navigationItem.title = I18NStrings.sendPriceOffer
    }
    
    private func bind() {
        
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
                
                ProductsManager.shared.suggestPrice(id: owner.id, price: price)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        onSuccess: { _ in
                            owner.showLoading()
                            owner.showSinglePopUpAlert(message: "제안 완료", actionCompletion: {
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
