//
//  ArtworkInfoVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit

final class ArtworkInfoVC: SZVC {
    // MARK: - Properties
    private let mainView = ArtworkInfoView()
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
        navigationItem.title = I18NStrings.artworkInfo
    }
}
