//
//  NewsModel.swift
//  NewsApp
//
//  Created by Adam Bokun on 16.02.22.
//

import Foundation

struct NewsModel: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Codable {
    var author: String?
    var title, articleDescription: String?
    var urlToImage: String?
    var publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case urlToImage, publishedAt
    }
}
