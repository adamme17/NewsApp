//
//  FavsViewController.swift
//  NewsApp
//
//  Created by Adam Bokun on 17.02.22.
//

import UIKit

class FavsViewController: UIViewController {
    
    let favsView = FavsView()
    var safeArea: UILayoutGuide!
    var dataSource = [FavoriteNews]()
    
    let newsManager: NewsManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    init (news: NewsManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol) {
        self.newsManager = news
        self.storageManager = storage
        self.networkManager = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = favsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let newsList = storageManager.fetchFavoritesNews()
        dataSource = newsList
        DispatchQueue.main.async {
            self.reloadTableView()
        }
        if newsList.isEmpty {
            favsView.titleLabel.isHidden = false
        } else {
            favsView.titleLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        favsView.tableView.dataSource = self
        favsView.tableView.delegate = self
        favsView.tableView.register(NewsCell.self, forCellReuseIdentifier: "cellId")
    }
}

extension FavsViewController: UITableViewDelegate {}

extension FavsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell()
        cell.selectionStyle = .none
        cell.setupStorageModel(model: dataSource[indexPath.row])
        return cell
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.favsView.tableView.reloadData()
        }
    }
}
