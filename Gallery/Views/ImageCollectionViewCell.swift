//
//  imageCollectionViewCell.swift
//  Gallery
//
//  Created by test on 02/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
    }
    
    func setImage(with id: String) {
        
        activityIndicatorView.startAnimating()
        CloudinaryManager.downloadImage(publicId: id) { [weak self] (image, error) in
            self?.activityIndicatorView.stopAnimating()
            if let image = image {
                self?.imageView.image = image
            }
        }
    }
    
}
