//
//  SelectAlignVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/02.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

final class SelectAlignVC: SZVC {
    
    // MARK: - Constant
    
    // MARK: - Property
    
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    let alignOptionSections: BehaviorRelay<[AlignOptionDataSection]> = BehaviorRelay(value: [
        AlignOptionDataSection(items: AlignOption.allCases.map {
            AlignOptionData(alignOption: $0)
        })
    ])
    
    let alignOptionDataSource: RxTableViewSectionedReloadDataSource<AlignOptionDataSection> = RxTableViewSectionedReloadDataSource<AlignOptionDataSection>(
        configureCell: { _, tableView, indexPath, item in
            guard let cell: SelectAlignTVC = tableView
                .dequeueReusableCell(
                    withIdentifier: SelectAlignTVC.identifier,
                    for: indexPath
                ) as? SelectAlignTVC else { return UITableViewCell() }
            cell.configureCell(with: item.alignOption)
            return cell
    })
    
    // MARK: - UI
    
    let sliderIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.label
        view.layer.cornerRadius = 3
        return view
    }()
    
    let selectTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = CustomColor.background
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        configureLayout()
        configureGesture()
        
        selectTableView.register(
            SelectAlignTVC.self,
            forCellReuseIdentifier: SelectAlignTVC.identifier
        )
        
        selectTableView.isScrollEnabled = false
        
    }
}

// MARK: - Bind

private extension SelectAlignVC {
    
    func bind() {
        
        alignOptionSections
            .bind(to: selectTableView.rx.items(dataSource: alignOptionDataSource))
            .disposed(by: disposeBag)
        
        selectTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView

extension SelectAlignVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 56.0
    }
}

// MARK: - Private

private extension SelectAlignVC {
    
    func configureLayout() {
    
        [
            sliderIndicator,
            selectTableView
        ].forEach { view.addSubview($0) }
        
        sliderIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(2.5)
            $0.width.equalTo(50.0)
            $0.height.equalTo(6)
        }
        
        selectTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureRecognizerAction)
        )
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Selector
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
