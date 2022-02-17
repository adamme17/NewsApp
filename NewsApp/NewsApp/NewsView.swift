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
    
    internal func setupUI() {
        self.tableView.backgroundColor = .clear
        setup()
        setupConstraints()
    }
    
    internal func setup() {
        [tableView].forEach {addSubview($0)}
        backgroundColor = .clear
    }
    
    func setupConstraints() {
        super.updateConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
