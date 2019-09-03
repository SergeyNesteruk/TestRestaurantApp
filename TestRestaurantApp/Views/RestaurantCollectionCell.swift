//
//  RestaurantCollectionCellView.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/3/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation
import UIKit

class RestaurantCollectionCell: UICollectionViewCell {
    static let identifier = String(describing: type(of: self))
    var restaurantView: RestaurantCellView!
    var lastFetchedUrl: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        // Add a content view
        let nib = UINib(nibName: String(describing: RestaurantCellView.self), bundle: nil)
        restaurantView = (nib.instantiate(withOwner: nil, options: nil)[0] as! RestaurantCellView)
        restaurantView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(restaurantView)
        restaurantView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        restaurantView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        restaurantView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        restaurantView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(model: RestaurantModel) {
        restaurantView.restaurantNameLabel.text = model.name
        restaurantView.dishNameLabel.text = model.dish
        restaurantView.priceLabel.text = "$\(String(format: "%.2f", model.price))"
        let imageURL = model.imageURL
        lastFetchedUrl = model.imageURL
        ImageDownloader.instance.loadImage(url: imageURL) { (image) in
            DispatchQueue.main.async {
                // Make sure we are still loading image from the needed url
                if (imageURL == self.lastFetchedUrl) {
                    self.restaurantView.imageView.image = image
                    self.lastFetchedUrl = nil
                }
            }
        }
    }
}
