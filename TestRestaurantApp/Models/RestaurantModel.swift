//
//  RestaurantModel.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/2/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation

struct RestaurantModel: Decodable {
    
    let name: String
    let dish: String
    let price: Double
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name = "restaurant"
        case dish = "food_name"
        case price
        case imageURLString = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        dish = try container.decode(String.self, forKey: .dish)
        price = try container.decode(Double.self, forKey: .price)
        
        // Model will only be created when all fields including umageURL are initialized
        let urlString = try container.decode(String.self, forKey: .imageURLString)
        guard let url = URL(string: urlString) else {
            let context = DecodingError.Context(codingPath: [CodingKeys.imageURLString],
                                                debugDescription: "Restaurant URL is corrupted.")
            throw DecodingError.dataCorrupted(context)
        }
        imageURL = url
    }
}
