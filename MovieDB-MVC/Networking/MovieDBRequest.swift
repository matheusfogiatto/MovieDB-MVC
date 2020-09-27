//
//  MovieDBRequest.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import Foundation
import UIKit

enum ResultError: String, Error {
    case unableToComplete = "Unable to complete your request. Check internet connection."
    case invalidResponse = "Invalid response from server."
    case invalidData = "The data receibed from the server is invalid. Please try again"
}

struct  MoviesResults: Codable {
    var results : [Movie]
}

struct  MovieDetailsResult: Codable {
    var results : MovieImages
}

class MovieDBResquest {
    
    let API_KEY = "71e9aa47b38db25bc9b3aca8210619b0"
    
    static var sharedInstance = MovieDBResquest()
    
    let cache = NSCache<NSString, UIImage>()
    
    // Fixed urls
    let popularMoviesBaseUrl: String = "https://api.themoviedb.org/3/movie/popular?api_key="
    let imageBaseUrl: String = "https://image.tmdb.org/t/p/w500"
    
    func fetchMovies(with page: Int, completion: @escaping (Result<[Movie], ResultError>) -> Void) {
        var urlString: String = ""
        
        urlString = "\(popularMoviesBaseUrl)\(API_KEY)&language=en-US&page=\(page)"
        
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                var movies : [Movie] = []
                if let moviesResults = try? decoder.decode(MoviesResults.self, from: data) {
                    movies = moviesResults.results
                } else {
                    throw ResultError.invalidData
                }
                
                
                completion(.success(movies))
            } catch {
                print(error)
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
        
    }
    
    func getMovieImages(movieId: Int, completion: @escaping (Result<MovieImages, ResultError>) -> Void) {
        
        var urlString: String = ""
        
        urlString = "https://api.themoviedb.org/3/movie/\(movieId)/images?api_key=\(API_KEY)"
        
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                
                return
            }
            
            do {
                let movieDetails = try JSONDecoder().decode(MovieImages.self, from: data)
                completion(.success(movieDetails))
                
            } catch {
                print(error)
                completion(.failure(.invalidData))
            }
            
            
        }
        task.resume()
    }
    
    func fetchImageFromUrl(poster_path: String, completion: @escaping(UIImage) -> Void) {
        guard let url = URL(string: "\(imageBaseUrl)\(poster_path)") else {return}
        
        let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                print("Error to fetch image \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                print("error to try fetch data")
                return
            }
            guard let image = UIImage(data: data) else {return}
            self.cache.setObject(image, forKey: NSString(string: poster_path))
            completion(image)
            
        }
        task.resume()
    }
    
    func getImageFromUrl(poster_path: String, completion: @escaping (Result <UIImage, ResultError>) -> Void) {
        
        
        guard let url = URL(string: "\(imageBaseUrl)\(poster_path)") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let image = UIImage(data: data) else {return}
            self.cache.setObject(image, forKey: NSString(string: poster_path))
            completion(.success(image))
        }
        
        task.resume()
    }
    
    func getLocalImage(from posterPath: String) -> UIImage{
        let cacheKey = NSString(string: posterPath)
        
        guard let image = cache.object(forKey: cacheKey) else {
            var image: UIImage = UIImage()
            
            getImageFromUrl(poster_path: posterPath) { result in
                switch result {
                case .success(let resultImage):
                    image =  resultImage
                case .failure(_): break
                    
                }
            }
            return image
        }
        return image
    }
}


