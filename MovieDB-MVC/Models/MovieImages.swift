//
//  MovieImages.swift
//  MovieDB-MVC
//
//  Created by Matheus Fogiatto on 27/09/20.
//

import Foundation

struct MovieImages: Codable {
    var id: Int
    var backdrops: [Backdrops]
}

struct Backdrops: Codable {
    let file_path: String
}
