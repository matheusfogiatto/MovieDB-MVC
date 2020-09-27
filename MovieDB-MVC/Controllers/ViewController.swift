//
//  ViewController.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Just for test API result
        MovieDBResquest.sharedInstance.fetchMovies(with: 1, completion: { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    print(movies)
                }
            case .failure(_):
                print("fail to show movies in the view∫")
            }
            
        });
    }
    
    
}

