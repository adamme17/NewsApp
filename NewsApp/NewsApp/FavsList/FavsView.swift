//
//  FavsView.swift
//  NewsApp
//
//  Created by Adam Bokun on 19.02.22.
//

import UIKit
import SnapKit

class FavsView: UIView {
   
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        return tableView
    }()
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "You have to save the news"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
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
    
    // MARK: - Setup
    
    internal func setupUI() {
        self.tableView.backgroundColor = .clear
        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel.isHidden = true
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
