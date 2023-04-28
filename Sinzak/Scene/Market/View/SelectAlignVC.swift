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
    private var currnetAlign: BehaviorRelay<AlignOption>
    private let refresh: () -> Void
    
    // MARK: - Sections
    private let alignOptionSections: BehaviorRelay<[AlignOptionDataSection]> = BehaviorRelay(value: [
        AlignOptionDataSection(items: AlignOption.allCases.map {
            AlignOptionData(alignOption: $0)
        })
    ])
    
    // MARK: - DataSource
    private lazy var alignOptionDataSource: RxTableViewSectionedReloadDataSource<AlignOptionDataSection> = RxTableViewSectionedReloadDataSource<AlignOptionDataSection>(
        configureCell: { [weak self] _, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            guard let cell: SelectAlignTVC = tableView
                .dequeueReusableCell(
                    withIdentifier: SelectAlignTVC.identifier,
                    for: indexPath
                ) as? SelectAlignTVC else { return UITableViewCell() }
            cell.configureCell(with: item.alignOption)
            cell.selectionStyle = .none
            if item.alignOption == self.currnetAlign.value {
                cell.isSelected = true
                cell.checkImageView.isHidden = false
            }
                        
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
    
    init(
        with currentAlign: BehaviorRelay<AlignOption>,
        _ refresh: @escaping () -> Void
    ) {
        self.currnetAlign = currentAlign
        self.refresh = refresh
        
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
        
        selectTableView.backgroundColor = CustomColor.background
        
        selectTableView.isScrollEnabled = false
        selectTableView.separatorStyle = .none
    }
}

// MARK: - Bind

private extension SelectAlignVC {
    
    func bind() {
        
        alignOptionSections
            .bind(to: selectTableView.rx.items(dataSource: alignOptionDataSource))
            .disposed(by: disposeBag)
        
        selectTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectAlignOption(with: indexPath)
            })
            .disposed(by: disposeBag)
        
        selectTableView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectAlignOption(with: indexPath)
            })
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
    
    func getSelectAlignCell(with indexPath: IndexPath) -> SelectAlignTVC {
        guard let cell = selectTableView
            .cellForRow(at: indexPath) as? SelectAlignTVC else { return SelectAlignTVC() }
        
        return cell
    }
    
    func configureGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGestureRecognizerAction)
        )
        view.addGestureRecognizer(panGesture)
    }
    
    func selectAlignOption(with indexPath: IndexPath) {
        let selectedCell = getSelectAlignCell(with: indexPath)
        selectedCell.checkImageView.isHidden = false
        self.currnetAlign.accept(selectedCell.alignOption ?? .recommend)
        (0..<AlignOption.allCases.count).forEach {
            let cell = getSelectAlignCell(with: IndexPath(row: $0, section: 0))
            if cell.alignOption != selectedCell.alignOption {
                cell.checkImageView.isHidden = true
            }
        }
        dismiss(animated: true)
        refresh()
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
