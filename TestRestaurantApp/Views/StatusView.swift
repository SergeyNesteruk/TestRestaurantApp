//
//  StatusView.swift
//  TestRestaurantApp
//
//  Created by Sergii Nesteruk on 9/3/19.
//  Copyright © 2019 NLab. All rights reserved.
//

import Foundation
import UIKit

class StatusView: UIView {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    
    typealias ReloadHandler = () -> Void
    var reloadHandler: ReloadHandler?
    
    func showLoading(message: String) {
        statusLabel.text = message
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        reloadButton.isHidden = true
        reloadHandler = nil
    }
    
    func showReloadButton(errorMessage message: String, reloadHandler handler: @escaping ReloadHandler) {
        statusLabel.text = message
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        reloadButton.isHidden = false
        reloadHandler = handler
    }
    
    @IBAction func reloadButtonTapped() {
        guard let handler = reloadHandler else { return }
        reloadHandler = nil
        handler()
    }
    
}
