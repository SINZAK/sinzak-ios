//
//  ConciergeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit
import RxSwift
import RxRelay

final class ConciergeVC: UIViewController {
    
    let disposeBag = DisposeBag()
    let mainView = ConciergeView()
    
    let nextVC: PublishRelay<UIViewController> = .init()
    let endAnimation: PublishRelay<Bool> = .init()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColor.background
        
        Observable.zip(nextVC.asObservable(), endAnimation.asObservable())
            .subscribe(onNext: { vc, _ in
                UserInfoManager.shared.logUserInfo()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                    .changeRootVC(vc, animated: false)
            })
            .disposed(by: disposeBag)
        
        getNextVC()
        concierge()
    }
    
    func concierge() {
        // 유저 정보 저장해야함
        mainView.logoView.play { [weak self] _ in
            // TODO: 네트워크 상태와 자동로그인 여부 확인하여 분기
            
            self?.endAnimation.accept(true)
        }
    }
    
    func getNextVC() {
        UserInfoManager.shared.logUserInfo()
        if UserInfoManager.isLoggedIn {
            AuthManager.shared.reissue()
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(
                    with: self,
                    onSuccess: { owner, _ in
                        AuthManager.shared.fetchMyProfile()
                            .observe(on: MainScheduler.asyncInstance)
                            .subscribe(
                                onSuccess: { _ in
                                    owner.nextVC.accept(TabBarVC())
                                }, onFailure: { error in
                                    Log.error(error)
                                    let root = LoginVC(viewModel: DefaultLoginVM())
                                    let vc = UINavigationController(rootViewController: root)
                                    owner.nextVC.accept(vc)
                                })
                            .disposed(by: owner.disposeBag)
                    },
                    onFailure: { owner, error in
                        let root = LoginVC(viewModel: DefaultLoginVM())
                        let vc = UINavigationController(rootViewController: root)
                        owner.nextVC.accept(vc)
                        Log.error(error)
                    }
                )
                .disposed(by: disposeBag)
        } else {
            let root = LoginVC(viewModel: DefaultLoginVM())
            let vc = UINavigationController(rootViewController: root)
            
            //            let vc = TabBarVC()
            nextVC.accept(vc)
        }
    }
}
