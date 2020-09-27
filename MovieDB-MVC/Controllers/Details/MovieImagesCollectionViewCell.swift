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
        MovieDBRequest.sharedInstance.getLocalImage(from: url) { results in
            switch results {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageBackdrop.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
