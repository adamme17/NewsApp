//
//  NewsModel.swift
//  NewsApp
//
//  Created by Adam Bokun on 16.02.22.
//

import Foundation

struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title, articleDescription: String
    let urlToImage: String
    let publishedAt: Date

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case urlToImage, publishedAt
    }
}
