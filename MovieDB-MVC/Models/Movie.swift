//
//  Movie.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import Foundation

struct Movie: Codable {
    
    var id: Int
    var title: String
    var overview: String
    var vote_average: Double
    var poster_path: String
}
