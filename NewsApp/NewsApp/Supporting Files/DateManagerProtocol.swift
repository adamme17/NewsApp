//
//  DateManagerProtocol.swift
//  NewsApp
//
//  Created by Adam Bokun on 19.02.22.
//

import Foundation

protocol DateManagerProtocol {
    func formatDate(date: String) -> String
    func getCurrentDate() -> String
    func getCurrentDatebyDate() -> Date?
    func getDefaultPreviousDate() -> String
    func getPreviousDate(current: String) -> String
    func getSeventhDayBeforeCurrentDay() -> Date?
    func getDate(string: String) -> Date?
}
