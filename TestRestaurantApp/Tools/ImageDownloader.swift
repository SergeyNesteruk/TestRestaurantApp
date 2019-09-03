//
//  ImageDownloader.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/3/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    static let instance = ImageDownloader()
    private var cachedImages = [URL: UIImage]()
    private let cachingQueue = DispatchQueue(label: "NL.TestRestaurantApp.CachingQueue", qos: .userInitiated)
    
    /// Asynchronously fetches image from the specified url.
    ///
    /// - parameter url: URL to fetch image from.
    /// - parameter completionHandler: Is called when image is fetched.
    func loadImage(url: URL, completionHandler: @escaping(UIImage?) -> Void) {
        
        // First - try to fetch cached image
        if let cachedImage = fetchCachedImage(url: url) {
            
            // Image fetched from cache successfully - return one
            completionHandler(cachedImage)
            return
        }
        
        // Otherwise - download image from net
        let dataTask = URLSession.shared.dataTask(with: url) {(data, respose, error) in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            
            // Try to chache image temporarily if downloading was successful
            if let image = UIImage(data: data) {
                completionHandler(image)
                self.cacheImage(url: url, image: image)
            }
            else {
                completionHandler(nil)
            }
        }
        dataTask.resume()
    }
    
    func purgeCache()
    {
        cachingQueue.async {
            self.cachedImages.removeAll()
        }
    }
    
    private func fetchCachedImage(url: URL) -> UIImage? {
        var image: UIImage?
        cachingQueue.sync {
            image = cachedImages[url]
        }
        return image
    }
    
    private func cacheImage(url: URL, image: UIImage) {
        cachingQueue.sync {
            cachedImages[url] = image
        }
    }
}
