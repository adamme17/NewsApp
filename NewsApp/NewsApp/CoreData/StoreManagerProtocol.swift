//
//  StoreManagerProtocol.swift
//  NewsApp
//
//  Created by Adam Bokun on 18.02.22.
//

import Foundation

protocol StoreManagerProtocol {
    static func shared() -> CoreDataManager
    func applicationLibraryDirectory()
    func prepareFavorites(dataForSaving: [Article]) -> Bool
    func saveData() -> Bool
    func fetchFavoritesNews() -> [FavoriteNews]
    func deleteItemFromFavorites(title: String) -> Bool
}
