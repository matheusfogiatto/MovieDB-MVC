//
//  MovieImagesCollectionViewCell.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import UIKit

class MovieImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBackdrop: UIImageView!
    
    func configure(with imageURL: String) {
        
        imageBackdrop.image = UIImage()
        loadImage(url: imageURL)
    }
    
    func loadImage(url: String) {
        MovieDBResquest.sharedInstance.fetchImageFromUrl(poster_path: url) { imageResult in
            DispatchQueue.main.async {
                self.imageBackdrop.image = imageResult
            }
        }
    }
}
