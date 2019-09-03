//
//  RestaurantsDataController.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/3/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation

protocol RestaurantDataControllerDelegate: class {
    func dataControllerWillStartDownloading()
    func dataControllerDidEndDownloading()
    func dataControllerDidFail(message: String)
}

class RestaurantDataController {
    var restaurants = [RestaurantModel]()
    weak var delegate: RestaurantDataControllerDelegate?
    
    func downloadRestaurants() {
        guard !RestaurantDownloader.loading else { return }
        delegate?.dataControllerWillStartDownloading()
        RestaurantDownloader.downloadRestaurants { (result) in
            switch result {
            case let .failure(error):
                switch error {
                case .corruptedData:
                    self.delegate?.dataControllerDidFail(message: "Restaurants data is corrupted.")
                    
                case .loadingError(let loadingErr):
                    self.delegate?.dataControllerDidFail(message: loadingErr.localizedDescription)
                    
                default:
                    self.delegate?.dataControllerDidFail(message: "Unknown error.")
                }
                
            case let .success(restaurants):
                self.restaurants = restaurants
                self.delegate?.dataControllerDidEndDownloading()
            }
        }
    }
}
