//
//  FailableDecodable.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/2/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        base = try container.decode(Base.self)
    }
}
