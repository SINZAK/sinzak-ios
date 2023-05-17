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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func nextButtonTapped(_ sender: UIButton) {
        let vc = ArtworkSizeVC()
        navigationController?.pushViewController(vc, animated: false)
    }
    // MARK: - Helpers
    override func configure() {
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = I18NStrings.artworkInfo
    }
}
