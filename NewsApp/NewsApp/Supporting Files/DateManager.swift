//
//  DateManager.swift
//  NewsApp
//
//  Created by Adam Bokun on 18.02.22.
//

import Foundation

struct DateManager: DateManagerProtocol {
    
    static let shared = DateManager()
    
    private init() {}

    func formatDate(date: String) -> String {
        let ISOdateFormatter = DateFormatter()
        ISOdateFormatter.locale = Locale(identifier: "en_US_POSIX")
        ISOdateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yy"

        guard let date = ISOdateFormatter.date(from: date) else {
            return date }
        return dateFormatter.string(from: date)
    }
    
    func getCurrentDate() -> String {
        let current = Date()
        let currentDate = current.toString(dateFormat: "yyyy-MM-dd")
        print(currentDate)
        return currentDate
    }
    
    func getCurrentDatebyDate() -> Date? {
        let current = Date()
        return current
    }
    
    func getDefaultPreviousDate() -> String {
        let date = Date()
        let next: Date? = Calendar.current.date(byAdding: .day, value: -1, to: date)
        let nextDate = next!.toString(dateFormat: "yyyy-MM-dd")
        return nextDate
    }
    
    func getPreviousDate(current: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from:current) else { return "" }
        let next: Date? = Calendar.current.date(byAdding: .day, value: -2, to: date)
        let nextDate = next!.toString(dateFormat: "yyyy-MM-dd")
        return nextDate
    }
    
    func getSeventhDayBeforeCurrentDay() -> Date? {
        let date = Date()
        let nextDate: Date? = Calendar.current.date(byAdding: .day, value: -8, to: date)
        return nextDate
    }
    
    func getDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }
}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
