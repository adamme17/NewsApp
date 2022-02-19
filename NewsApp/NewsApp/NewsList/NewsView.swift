//
//  NewsView.swift
//  NewsApp
//
//  Created by Adam Bokun on 16.02.22.
//

import UIKit
import SnapKit

class NewsView: UIView {
   
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = false
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    // MARK: - Setup
    
    internal func setupUI() {
        self.tableView.backgroundColor = .clear
        setup()
        setupConstraints()
    }
    
    internal func setup() {
        [tableView, searchBar].forEach {addSubview($0)}
        backgroundColor = .clear
    }
    
    func addSpinner() {
        DispatchQueue.main.async {
            self.addSubview(self.spinner)
            self.spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.spinner.startAnimating()
            self.spinner.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }            
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinner.removeFromSuperview()
        }
    }
    
    func setupConstraints() {
        super.updateConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(5.0)
            make.leading.bottom.trailing.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50.0)
        }
    }
}
