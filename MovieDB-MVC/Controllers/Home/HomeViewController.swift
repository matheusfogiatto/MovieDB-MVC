//
//  HomeViewController.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Constants
    private let NUMBER_OF_SECTIONS = 1
    
    // MARK: - Outlets
    @IBOutlet weak var moviesTableView: UITableView!
    
    // MARK: - Variables
    var movies: [Movie] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Popular Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let nibName = UINib(nibName: "MovieTableViewCell", bundle: nil)
        self.moviesTableView.register(nibName, forCellReuseIdentifier: "MovieTableViewCell")
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        loadData()
    }
    
    // MARK: - Methods
    func loadData() {
        MovieDBResquest.sharedInstance.fetchMovies(with: 1, completion: { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    self.moviesTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        });
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MovieTableViewCell"
        guard let cell = moviesTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }
        
        cell.movie = movies[indexPath.row]
        cell.setup()
        
        return cell
    }
}

