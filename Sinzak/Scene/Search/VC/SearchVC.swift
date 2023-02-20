//
//  SearchVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/14.
//

import UIKit

final class SearchVC: SZVC {
    // MARK: - Properties
    private let mainView = SearchView()
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configure() {
        tabBarController?.tabBar.isHidden = true
    }
    override func setNavigationBar() {
        super.setNavigationBar()
        let searchBar = UISearchBar()
        searchBar.placeholder = I18NStrings.workRequestSearchPlaceholder
        self.navigationItem.titleView = searchBar
    }
}
