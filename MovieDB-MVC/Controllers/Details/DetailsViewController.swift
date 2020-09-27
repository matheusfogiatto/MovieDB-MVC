//
//  DetailsViewController.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Variables
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = self.movie else { return }
        title = "Movie Details"
        configure(with: movie)
        
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        ratingLabel.text = "\(movie.vote_average)"
        self.movieImage.image = UIImage()
        loadImage(url: movie.poster_path)
    }
    
    func loadImage(url: String) {
        MovieDBResquest.sharedInstance.fetchImageFromUrl(poster_path: url) { imageResult in
            DispatchQueue.main.async {
                self.movieImage.image = imageResult
            }
        }
    }

}
