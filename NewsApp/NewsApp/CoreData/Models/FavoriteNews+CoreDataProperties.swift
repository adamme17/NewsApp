//
//  FavoriteNews+CoreDataProperties.swift
//  NewsApp
//
//  Created by Adam Bokun on 18.02.22.
//
//

import Foundation
import CoreData


extension FavoriteNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteNews> {
        return NSFetchRequest<FavoriteNews>(entityName: "FavoriteNews")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?

}

extension FavoriteNews : Identifiable {

}
