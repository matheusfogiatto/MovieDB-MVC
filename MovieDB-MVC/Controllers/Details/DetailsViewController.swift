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
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: Variables
    var movie: Movie?
    var imagesBackdropsList: MovieImages?
    var viewWidthSize: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        guard let movie = self.movie else { return }
        title = "Movie Details"
        configure(with: movie)

        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        MovieDBRequest.sharedInstance.getMovieImages(movieId: movie?.id ?? 0, completion: { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self.imagesBackdropsList = movie
                    self.viewWidthSize = self.view.layer.bounds.width
                    self.imagesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        });
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        ratingLabel.text = "\(movie.vote_average)"
        self.movieImage.image = UIImage()
        loadImage(url: movie.poster_path)
    }
    
    func loadImage(url: String) {
        
        self.movieImage.image = UIImage()
        
        MovieDBRequest.sharedInstance.getLocalImage(from: url) { results in
            switch results {
            case .success(let image):
                DispatchQueue.main.async {
                    self.movieImage.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesBackdropsList?.backdrops.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieImagesCollectionViewCell", for: indexPath) as? MovieImagesCollectionViewCell
        
        cell?.configure(with: imagesBackdropsList?.backdrops[indexPath.row].file_path ?? "")
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewWidthSize * 0.8, height: 200)
    }
}
