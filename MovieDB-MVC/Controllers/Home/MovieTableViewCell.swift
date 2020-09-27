//
//  MovieTableViewCell.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Variables
    var coverSessionTask: URLSessionTask?
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        self.titleLabel.text = movie?.title
        descriptionLabel.text = movie?.overview
        ratingLabel.text = "\(movie?.vote_average ?? 0.0)"
        self.movieImage.image = UIImage()
        loadImage(url: movie?.poster_path ?? "")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.selectionStyle = .none
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadImage(url: String) {
        MovieDBRequest.sharedInstance.fetchImageFromUrl(poster_path: url) { imageResult in
            DispatchQueue.main.async {
                self.movieImage.image = imageResult
            }
        }
    }
    
}
