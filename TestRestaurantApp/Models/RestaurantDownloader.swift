//
//  RestaurantDownloader.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/2/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation

struct RestaurantDownloader {
    
    // Constants
    private static let urlString = """
https://gist.githubusercontent.com/gonchs/b657e6043e17482cae77a633d78f8e83/\
raw/7654c0db94a3f430888fac0caac675c7e811030a/test_data.json
"""
    private static let restaurantsURL = URL(string: urlString)!
    
    
    enum DownloadError: Error {
        case loadingInProgress
        case corruptedData
        case loadingError(Error)
    }
    
    /// Should only be modified under `captureLoadingState()`
    private (set) static var loading = false
    private static let loadingQueue = DispatchQueue(label: "NL.TestRestaurantApp.LoadingQueue", qos: .userInitiated)
    
    static func downloadRestaurants(completion: @escaping (Result<[RestaurantModel], DownloadError>) -> Void) {
        
        // We quit immidiately if loading is in progress otherwise we capture loading state and continue
        guard captureLoadingState() else { completion(.failure(.loadingInProgress)); return }
        let task = URLSession.shared.dataTask(with: restaurantsURL) { (data, response, error) in
            
            // Don't forget to release loading state
            defer {
                releaseLoadingState()
            }
            
            // In case of error return failure and error description
            if let error = error {
                completion(.failure(.loadingError(error)))
                return
            }
            
            // Make sure data is valid, otherwise `corruptedData` is returned as failure reason
            guard let data = data else { completion(.failure(.corruptedData)); return }
            
            // Data is here - let's parse that
            let decoder = JSONDecoder()
            do {
                let models = try decoder.decode([FailableDecodable<RestaurantModel>].self, from: data).compactMap{$0.base}
                completion(.success(models))
            }
            catch {
                completion(.failure(.corruptedData))
            }
        }
        task.resume()
    }
    
    private static func captureLoadingState() -> Bool {
        var captured = false
        loadingQueue.sync {
            guard !loading else { return }
            loading = true
            captured = true
        }
        return captured
    }
    
    private static func releaseLoadingState() {
        loadingQueue.sync {
            guard loading else { return }
            loading = false
        }
    }
}
