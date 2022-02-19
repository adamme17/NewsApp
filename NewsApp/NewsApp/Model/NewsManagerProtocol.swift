//
//  NewsManagerProtocol.swift
//  NewsApp
//
//  Created by Adam Bokun on 17.02.22.
//

import Foundation

protocol NewsManagerProtocol {
    func getNews(currentDate: String, nextDate: String, completion: @escaping (Result<NewsModel, Error>) -> Void)
}
