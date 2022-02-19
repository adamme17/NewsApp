//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Adam Bokun on 16.02.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let tabBarController = UITabBarController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        let rootViewController = viewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func viewController() -> UIViewController {
        let network: NetworkManagerProtocol = NetworkManager()
        let news: NewsManagerProtocol = NewsManager()
        let store: StoreManagerProtocol = CoreDataManager.shared()
        
        let newsVC = ViewController(news: news, storage: store, network: network)
        newsVC.navigationItem.title = "News"
        let newsNavController = UINavigationController(rootViewController: newsVC)
        let favoritesVC = FavsViewController(news: news, storage: store, network: network)
        let favsNavController = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.navigationItem.title = "Favorites"
        
        tabBarController.title = "News"
        newsVC.title = "News"
        favoritesVC.title = "Favs"

        tabBarController.setViewControllers([newsNavController, favsNavController], animated: true)

        guard let items = tabBarController.tabBar.items else { return UINavigationController() }

        let images = ["book.fill", "bookmark.fill"]

        for item in 0...1 {
            items[item].image = UIImage(systemName: images[item])
        }
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.backgroundColor = .white
        
        return tabBarController
    }
}

extension SceneDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}

