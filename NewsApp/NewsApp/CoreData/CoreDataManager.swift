//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by Adam Bokun on 18.02.22.
//

import Foundation
import CoreData

class CoreDataManager: NSObject, StoreManagerProtocol {
    
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    override init() {
        super.init()
        applicationLibraryDirectory()
        privateMOC.parent = managedObjectContext
    }
    
    private lazy var storeQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Store queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    static let sharedConst = CoreDataManager()
    
    class func shared() -> CoreDataManager {
        return sharedConst
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    internal func applicationLibraryDirectory() {
        print(applicationDocumentsDirectory)
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "Articles", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "Articles.sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        print(persistentStoreURL)
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                      NSMigratePersistentStoresAutomaticallyOption : true]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        return persistentStoreCoordinator
    }()
    
    func prepareFavorites(dataForSaving: [Article]) -> Bool {
        _ = dataForSaving.map {self.createEntityFrom(articles: $0)}
        return saveData()
    }
    
    internal func createEntityFrom(articles: Article) -> FavoriteNews? {
        let newsItem = FavoriteNews(context: self.managedObjectContext)
        newsItem.title = articles.title
        newsItem.author = articles.author
        newsItem.articleDescription = articles.articleDescription
        newsItem.publishedAt = articles.publishedAt
        newsItem.urlToImage = articles.urlToImage
        
        return newsItem
    }
    
    func saveData() -> Bool {
        
        let context = self.managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let nserror = error as NSError
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func fetchFavoritesNews() -> [FavoriteNews] {
        var favorites = [FavoriteNews]()
        self.storeQueue.addOperation {
            let fetchRequest: NSFetchRequest<FavoriteNews> = FavoriteNews.fetchRequest()
            do {
                let context = self.managedObjectContext
                let objects = try context.fetch(fetchRequest)
                favorites += objects
            } catch let error {
                print(error.localizedDescription)
            }
        }
        self.storeQueue.waitUntilAllOperationsAreFinished()
        return favorites
    }
    
    func deleteItemFromFavorites(title: String) -> Bool {
         guard let favorite = fetchFavoritesNews()
                .first(where: { $0.title == title })
        else { return false }
        
        managedObjectContext.delete(favorite)
        return saveData()
    }
}
