//
//  RestaurantDetailViewController.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/3/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation
import UIKit

class RestaurantDetailViewController: UIViewController {
    var restaurant: RestaurantModel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameLabel.text = restaurant.name
    }
    
    @IBAction func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
