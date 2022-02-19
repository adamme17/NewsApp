//
//  NewsManager.swift
//  NewsApp
//
//  Created by Adam Bokun on 17.02.22.
//

import Foundation

private enum NetworkResponse: String, Error {
    case success
    case failed = "Error"
    case noData = "No data"
    case ubableToDecode = "Unable to decode"
}

final class NewsManager {
    let network = NetworkManager()
}

extension NewsManager: NewsManagerProtocol {
    func getNews(currentDate: String, nextDate: String, completion: @escaping (Result<NewsModel, Error>) -> Void) {
        network.request(currentDate: currentDate, nextDate: nextDate) { data, response, error in
            if error != nil {
                completion(.failure(NetworkResponse.failed))
                debugPrint("Failed")
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                    case 200...299:
                        guard let responseData = data else {
                            completion(.failure(NetworkResponse.noData))
                            debugPrint("No data")
                            return
                        }
                        do {
                            let apiResponse = try JSONDecoder().decode(NewsModel.self, from: responseData)
                            completion(.success(apiResponse))
                            debugPrint("Request - success")
                        } catch {
                            completion(.failure(NetworkResponse.ubableToDecode))
                            debugPrint("Unable to decode")
                        }
                    default:
                        print(response.description)
                        print(response.statusCode)
                        completion(.failure(NetworkResponse.failed))
                }
            }
        }
    }
}
