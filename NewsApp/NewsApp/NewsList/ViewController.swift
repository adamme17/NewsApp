//
//  ViewController.swift
//  NewsApp
//
//  Created by Adam Bokun on 16.02.22.
//

import UIKit

class ViewController: UIViewController {
    
    let newsView = NewsView()
    var safeArea: UILayoutGuide!
    let newsOperationQueue = OperationQueue()
    
    var dataSource = [Article]()
    var newsSource = [Article]()
    
    let newsManager: NewsManagerProtocol
    let storageManager: StoreManagerProtocol
    let networkManager: NetworkManagerProtocol
    
    var currentDate = DateManager.shared.getCurrentDate()
    var nextDate = DateManager.shared.getDefaultPreviousDate()
    
    init (news: NewsManagerProtocol, storage: StoreManagerProtocol, network: NetworkManagerProtocol) {
        self.newsManager = news
        self.storageManager = storage
        self.networkManager = network
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadNewsPage (currentDate: String, nextDate: String) {
        guard let current = DateManager.shared.getDate(string: currentDate),
              let sevenDaysAgo = DateManager.shared.getSeventhDayBeforeCurrentDay(),
                       current >= sevenDaysAgo
               else { return }
        
        newsOperationQueue.addOperation { [weak self] in
            guard let self = self else { return }
            self.newsManager.getNews(currentDate: currentDate, nextDate: currentDate) { result in
                switch result {
                case .success(let news):
                    let news = news.articles
                    if news.isEmpty {
                        self.loadNewsPage(currentDate: nextDate, nextDate: nextDate)
                    }
                   for oneNews in news {
                       self.dataSource.append(oneNews)
                       self.newsSource.append(oneNews)
                    }
                    self.reloadTableView()
                    self.newsView.removeSpinner()
                    self.currentDate = nextDate
                    print("current date " + currentDate)
                    self.nextDate = DateManager.shared.getPreviousDate(current: currentDate)
                    print("next date " + nextDate)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func loadView() {
        self.view = newsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsView.addSpinner()
        loadNewsPage(currentDate: currentDate, nextDate: nextDate)
        print("default current date " + currentDate)
        print("default next date " + nextDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupView()
        setupNavBar()
        newsView.searchBar.delegate = self
        newsView.tableView.dataSource = self
        newsView.tableView.delegate = self
        newsView.tableView.register(NewsCell.self, forCellReuseIdentifier: "cellId")
        
        newsOperationQueue.maxConcurrentOperationCount = 1
        newsOperationQueue.qualityOfService = .userInitiated
    }
    
    private func setupView() {
        newsView.searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
        }
        newsView.endEditing(true)
    }
    
    private func setupNavBar() {
        let rightBarItem = UIBarButtonItem(title: "Refresh",
                                           style: .plain,
                                           target: self,
                                           action: #selector(refreshButtonPressed))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc
    private func refreshButtonPressed() {
        currentDate = DateManager.shared.getCurrentDate()
        nextDate = DateManager.shared.getDefaultPreviousDate()
        self.reloadTableView()
        newsView.tableView.setContentOffset(.zero, animated:true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= dataSource.count - 1 || indexPath.row >= dataSource.endIndex {
            loadNewsPage(currentDate: currentDate, nextDate: nextDate)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell()
        cell.selectionStyle = .none
        cell.setupModel(model: dataSource[indexPath.row])
        return cell
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.newsView.tableView.reloadData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.dataSource = newsSource
        reloadTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterDataBySearchRequest()
    }
    
    private func filterDataBySearchRequest() {
        guard let searchText = self.newsView.searchBar.searchTextField.text else { return }
        if !searchText.isEmpty {
            self.dataSource = newsSource.filter({ news -> Bool in
                return news.title!.lowercased().contains(searchText.lowercased())
            })
            self.reloadTableView()
        } else {
            self.dataSource = newsSource
            reloadTableView()
        }
    }
}
