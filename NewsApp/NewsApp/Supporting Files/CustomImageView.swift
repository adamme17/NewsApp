//
//  CustomImageView.swift
//  NewsApp
//
//  Created by Adam Bokun on 17.02.22.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                self.image = nil
            }
            self.addSpinner()
            
            if let task = self.task {
                task.cancel()
            }
            if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.image = imageFromCache
                }
                self.removeSpinner()
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
                guard let data = data, let newImage = UIImage(data: data)
                else {
                    print("couldn't load image from url: \(url)")
                    DispatchQueue.main.async {
                        self.image = UIImage(named: "NoImage")
                        self.removeSpinner()
                    }
                    return
                }
                imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = newImage
                    self.removeSpinner()
                }
            }
            task.resume()
        }
    }
    
    func addSpinner() {
        DispatchQueue.main.async {
            self.addSubview(self.spinner)
            self.spinner.startAnimating()
            self.spinner.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.spinner.removeFromSuperview()
        }
    }
}
