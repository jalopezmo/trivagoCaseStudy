//
//  Constants.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 11/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import Foundation

struct Constants {
    
    enum API : String {
        case apiUrl = "https://api.trakt.tv/"
        case movieEndpoint = "movies/popular?"
        case searchEndpoint = "search/movie?"
        case pageParam = "page"
        case extendedParam = "extended"
        case queryParam = "query"
    }
    
    enum Headers : String {
        case apiKeyParam = "trakt-api-key"
        case apiKeyValue = "ad005b8c117cdeee58a1bdb7089ea31386cd489b21e14b19818c91511f12a086"
    }
    
    enum MovieAttributes : String {
        case title = "title"
        case tagline = "tagline"
        case overview = "overview"
        case releaseDate = "released"
        case runtime = "runtime"
        case trailerURL = "trailer"
        case rating = "rating"
        case genres = "genres"
        case images = "images"
        case poster = "poster"
        case thumbnail = "thumb"
        case movie = "movie"
    }
    
    enum Messages : String {
        case loading = "Loading..."
    }
}