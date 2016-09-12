//
//  Movie.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 11/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import Foundation

struct Movie {
    var title:String?
    var releaseDate:String?
    var tagline:String?
    var overview:String?
    var runtime:Int?
    var trailerURL:String?
    var genres:[String]?
    var thumbnailURL:String?
    var rating:Float?
    
    static func initWithDictionary(dictionary:[String:AnyObject]) -> Movie? {
        
        var movie = Movie()
        
        if let title = dictionary[Constants.MovieAttributes.title.rawValue] as? String {
            movie.title = title
        }
        
        if let releaseDate = dictionary[Constants.MovieAttributes.releaseDate.rawValue] as? NSNumber {
            movie.releaseDate = releaseDate.stringValue
        }
        
        if let tagline = dictionary[Constants.MovieAttributes.tagline.rawValue] as? String {
            movie.tagline = tagline
        }
        
        if let overview = dictionary[Constants.MovieAttributes.overview.rawValue] as? String {
            movie.overview = overview
        }
        
        if let runtime = dictionary[Constants.MovieAttributes.runtime.rawValue] as? NSNumber {
            movie.runtime = runtime.integerValue
        }
        
        if let trailerURL = dictionary[Constants.MovieAttributes.trailerURL.rawValue] as? String {
            movie.trailerURL = trailerURL
        }
        
        if let genres = dictionary[Constants.MovieAttributes.genres.rawValue]  as? [String] {
            movie.genres = genres
        }
        
        if let rating = dictionary[Constants.MovieAttributes.rating.rawValue] as? NSNumber {
            movie.rating = rating.floatValue
        }
        
        if let images = dictionary[Constants.MovieAttributes.images.rawValue] as? [String:AnyObject] {
            if let poster = images[Constants.MovieAttributes.poster.rawValue] as? [String:String] {
                if let thumb = poster[Constants.MovieAttributes.thumbnail.rawValue] {
                    movie.thumbnailURL = thumb
                }
            }
        }
        
        return movie
    }
}
