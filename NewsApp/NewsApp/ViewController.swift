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
    
    var someList = ["Zack", "Cody", "David", "Sam"]
    var dataSource = [NewsModel]()
    
    override func loadView() {
        self.view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        newsView.tableView.dataSource = self
        newsView.tableView.delegate = self
        newsView.tableView.register(NewsCell.self, forCellReuseIdentifier: "cellId")
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsCell()
        return cell
    }
}

