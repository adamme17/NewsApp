//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Adam Bokun on 17.02.22.
//

import Foundation

extension NetworkManager {
    enum ErrorHandler: Error {
        case invalidURL
    }
}

public class NetworkManager: NetworkManagerProtocol {

    typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    var task: URLSessionTask?
    
    func request (currentDate: String, nextDate: String, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            guard let request = try buildRequest(currentDate: currentDate, nextDate: nextDate)
            else {
                completion(nil, nil, ErrorHandler.invalidURL)
                return
            }
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }

    func cancel () {
        task?.cancel()
    }

    func buildRequest(currentDate: String, nextDate: String) throws -> URLRequest? {
        guard let requestUrl = URL(string: "https://newsapi.org/v2/everything?q=apple&from=\(nextDate)&to=\(currentDate)&sortBy=popularity&apiKey=de443a804f594dca96cdcf28329a8bcd")
        else { return nil }
        var request = URLRequest(url: requestUrl,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30.0)
        request.httpMethod = "GET"
        return request
    }
}
