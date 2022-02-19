//
//  NetworkManagerProtocol.swift
//  NewsApp
//
//  Created by Adam Bokun on 18.02.22.
//

import Foundation

protocol NetworkManagerProtocol {
    typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    func request (currentDate: String, nextDate: String, completion: @escaping NetworkRouterCompletion)
    func cancel ()
    func buildRequest(currentDate: String, nextDate: String) throws -> URLRequest?
}
