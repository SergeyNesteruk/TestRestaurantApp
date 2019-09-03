//
//  RestaurantsListViewController.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/2/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import UIKit

class RestaurantsListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataController = RestaurantDataController()
    let statusView: StatusView = {
        let nib = UINib(nibName: String(describing: StatusView.self), bundle: nil)
        let statusView = (nib.instantiate(withOwner: nil, options: nil)[0] as! StatusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        return statusView
    }()
    
    private let cellHeight: CGFloat = 189
    
    enum Segues: String {
        case detail = "ShowRestaurantDetail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(RestaurantCollectionCell.self, forCellWithReuseIdentifier: RestaurantCollectionCell.identifier)
        
        dataController.delegate = self
        dataController.downloadRestaurants()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIDString = segue.identifier, let segueID = Segues(rawValue: segueIDString) else { return }
        switch segueID {
        case Segues.detail:
            if let restaurant = sender as? RestaurantModel,
                let detailController = segue.destination as? RestaurantDetailViewController {
                detailController.restaurant = restaurant
            }
        }
    }
}

extension RestaurantsListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataController.restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionCell.identifier, for: indexPath)
        if let restaurantCell = cell as? RestaurantCollectionCell {
            restaurantCell.configure(model: dataController.restaurants[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.detail.rawValue, sender: dataController.restaurants[indexPath.row])
    }
}

extension RestaurantsListViewController: RestaurantDataControllerDelegate {
    func dataControllerWillStartDownloading() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.statusView.showLoading(message: "Downloading restaurants...")
            self.view.addSubview(self.statusView)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.statusView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": self.statusView]))
        }
    }
    
    func dataControllerDidEndDownloading() {
        DispatchQueue.main.async {
            self.statusView.isHidden = true
            self.statusView.removeFromSuperview()
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
        }
    }
    
    func dataControllerDidFail(message: String) {
        DispatchQueue.main.async {
            self.statusView.showReloadButton(errorMessage: message) {[weak self] in
                self?.dataController.downloadRestaurants()
            }
        }
    }
}

