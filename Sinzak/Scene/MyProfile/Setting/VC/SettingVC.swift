//
//  SettingVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/02.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKUser
import RxSwift

final class SettingVC: SZVC {
    // MARK: - Properties
    private let mainView = SettingView()
    private var dataSource: UICollectionViewDiffableDataSource<Setting, String>!

    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Helpers
    override func configure() {
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.setting
    }
}
extension SettingVC {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = CustomColor.white!
        config.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    private func configureDataSource() {
        // Cell Registration
        let cellRegistration =  UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.textProperties.font = .body_R
            // content.secondaryTextProperties.font = .body_R
            content.text = itemIdentifier
            // content.prefersSideBySideTextAndSecondaryText = false
            // content.secondaryText = itemIdentifier
            cell.contentConfiguration = content
            // 백그라운드 설정 
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeColor = CustomColor.gray40
            background.strokeWidth = 1
            background.cornerRadius = 20
            cell.backgroundConfiguration = background
        })
        // 헤더
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            // Obtain header item using index path
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            // Configure header view content based on headerItem
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.text
            // Customize header appearance to make it more eye-catching
            configuration.textProperties.font = .body_B
            configuration.textProperties.color = CustomColor.black!
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 14.0, trailing: 0.0)
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
        // Diffable Data Source
        // collectionView.dataSource = self 코드의 대체
        // CellForItemAt 대체
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration , for: indexPath, item: itemIdentifier)
            return cell
        })
        dataSource.supplementaryViewProvider  = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            if elementKind == UICollectionView.elementKindSectionHeader {
                // Dequeue header view
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            } else {
                return UICollectionReusableView()
            }
        }

        // 스냅샷, 모델을 Initialise 해줄 것
        // 스냅샷 타입은 위에 dataSource형태와 맞추기 (섹션, 모델타입)
        var snapshot = NSDiffableDataSourceSnapshot<Setting, String>()
        snapshot.appendSections([.personalSetting])
        snapshot.appendItems(Setting.personalSetting.content, toSection: .personalSetting)
        snapshot.appendSections([.usageGuide])
        snapshot.appendItems(Setting.usageGuide.content, toSection: .usageGuide)
        snapshot.appendSections([.etc])
        snapshot.appendItems(Setting.etc.content, toSection: .etc)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
// MARK: - Collection View Delegate
extension SettingVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 내용별로 하기
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath == [2, 0] { // 회원 탈퇴
            signout()
        }
        
        if indexPath == [2, 1] { // 로그 아웃
            logout()
        }
    }
}

private extension SettingVC {
    
    func logout() {
        let snsKind = SNS(rawValue: UserInfoManager.snsKind ?? "")
        switch snsKind {
        case .kakao:
            UserApi.shared.logout { error in
                if let error = error {
                    Log.error(error)
                } else {
                    Log.debug("Kakao logout() success.")
                }
            }
            
        case .naver:
            NaverThirdPartyLoginConnection.getSharedInstance()?.resetToken()
            
        case .apple:
            break
            
        default:
            Log.error("SNS 로그아웃 오류")
        }
        
        UserInfoManager.shared.logout(completion: { [weak self] in
            let vc = TabBarVC()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: {
                self?.navigationController?.popToRootViewController(animated: false)
            })
            
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
//                .changeRootVC(vc, animated: true)
        })
    }
    
    func signout() {
        let snsKind = SNS(rawValue: UserInfoManager.snsKind ?? "")
        switch snsKind {
        case .kakao:
            UserApi.shared.unlink { error in
                if let error = error {
                    Log.error(error)
                } else {
                    Log.debug("Kakao unlink() success.")
                }
            }
            
        case .naver:
            NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
            
        case .apple:
            AppleAuthManager.shared.revokeAppleToken()
            
        case .none:
            Log.error("SNS 회원 탈퇴 오류")
        }
    
        AuthManager.shared.resign()
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    Log.debug("회원 탈퇴 성공")
                    
                    UserInfoManager.shared.logout(completion: {
                        let vc = TabBarVC()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true, completion: {
                            owner.navigationController?.popToRootViewController(animated: false)                            
                        })
//                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
//                            .changeRootVC(vc, animated: true)
                        
                    })
                    
                }, onFailure: { _, error in
                    APIError.logError(error)
                })
            .disposed(by: disposeBag)
    }
}
