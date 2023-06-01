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
import MessageUI

final class SettingVC: SZVC {
    // MARK: - Properties
    private let mainView = SettingView()
    private var dataSource: UICollectionViewDiffableDataSource<Setting, String>!
    private let disposeBag = DisposeBag()

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
        navigationItem.title = "설정"
    }
}
extension SettingVC {
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = CustomColor.background
        config.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    private func configureDataSource() {
        // Cell Registration
        let cellRegistration =  UICollectionView.CellRegistration<UICollectionViewListCell, String>(
            handler: { cell, indexPath, itemIdentifier in
                var content = UIListContentConfiguration.valueCell()
                content.textProperties.font = .body_R
                 content.secondaryTextProperties.font = .body_R
                content.text = itemIdentifier
                // content.prefersSideBySideTextAndSecondaryText = false
//                content.secondaryText = itemIdentifier
                if itemIdentifier == "연결된 계정" {
                    content.secondaryText = UserInfoManager.snsKind ?? ""
                }
                if itemIdentifier == "앱 버전" {
                    content.secondaryText = "1.0.0"
                }
                
                cell.contentConfiguration = content
                // 백그라운드 설정
                var background = UIBackgroundConfiguration.listPlainCell()
                background.strokeColor = CustomColor.gray40
                background.strokeWidth = 1
                background.cornerRadius = 20
                background.backgroundColor = CustomColor.background
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
            configuration.textProperties.color = CustomColor.label
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 14.0, trailing: 0.0)
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
        // Diffable Data Source
        // collectionView.dataSource = self 코드의 대체
        // CellForItemAt 대체
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
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
        
        switch indexPath {
            
        case [1, 1]:
            sendInquiry()
            
        case [1, 2]:
            let vc = WebVC()
            vc.destinationURL = "https://sinzak.notion.site/64bb148cab2b49219a8d3d9309c80c87"
            present(vc, animated: true)
        
        case [1, 3]:
            let vc = WebVC()
            vc.destinationURL = "https://sinzak.notion.site/bfd66407b0ca4d428a8214165627c191"
            present(vc, animated: true)
            
        case [1, 4]:
            let vc = WebVC()
            vc.destinationURL = "https://sinzak.notion.site/cd0047fcc1d1451aa0375eae9b60f5b4"
            present(vc, animated: true)
            
        case [2, 0]:
            let vc = SignoutCheckVC()
            navigationController?.pushViewController(vc, animated: true)
            
        case [2, 1]:
            showPopUpAlert(
                message: "정말 로그아웃할까요?",
                rightActionTitle: "로그아웃",
                rightActionCompletion: { [weak self] in
                    self?.showLoading()
                    self?.logout()
                }
            )
            logout()
            
        default:
            break
        }
    }
}

private extension SettingVC {
    
    func sendInquiry() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            composeViewController.setToRecipients(["sinzakofficial@naver.com"])
            composeViewController.setSubject("[신작 앱 1:1문의]")
            
            present(composeViewController, animated: true)
        } else {
            showSinglePopUpAlert(message: "sinzakofficial@naver.com\n로 문의해주세요.")
        }
        
    }
    
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
            self?.hideLoading()
            self?.present(vc, animated: true, completion: {
                self?.navigationController?.popToRootViewController(animated: false)
            })
        })
    }
}

extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        dismiss(animated: true)
    }
}
