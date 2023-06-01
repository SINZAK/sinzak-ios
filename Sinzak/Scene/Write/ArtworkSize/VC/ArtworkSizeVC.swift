//
//  ArtworkSizeVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/25.
//

import UIKit

final class ArtworkSizeVC: SZVC {
    // MARK: - Properties
    private let mainView = ArtworkSizeView()
    // MARK: - Lifecycle
    override func loadView() {
        view =  mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Helpers
    override func configure() {
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "작품 사이즈(선택)"
    }
}
