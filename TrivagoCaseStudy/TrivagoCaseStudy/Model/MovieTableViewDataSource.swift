//
//  MovieTableViewDataSource.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 11/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieTableViewDataSource:NSObject {
    var movies = [Movie]()
    
    func getTrailerUrlForMovie(row:Int) -> String? {
        return movies[row].trailerURL
    }
    
    func clearDataSourceArray() {
        movies = [Movie]()
    }
}
extension MovieTableViewDataSource:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var movieCell:MovieCell
        
        if let checkedCell = tableView.dequeueReusableCellWithIdentifier(MovieCell.identifier) as? MovieCell {
            movieCell = checkedCell
        }
        else {
            tableView.registerClass(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
            movieCell = tableView.dequeueReusableCellWithIdentifier(MovieCell.identifier) as! MovieCell
        }
        
        if let title = movies[indexPath.row].title {
            movieCell.titleLabel.text = title
        }
        
        if let releaseDate = movies[indexPath.row].releaseDate {
            movieCell.titleLabel.text = movieCell.titleLabel.text! + " (\(releaseDate))"
        }
        
        if let overview = movies[indexPath.row].overview {
            movieCell.overviewLabel.text = overview
        }
        
        if let thumbnail = movies[indexPath.row].thumbnailURL {
            if let thumbnailURL = NSURL(string: thumbnail), let placeholder = UIImage(named: "placeholder") {
                movieCell.thumbnailImage.af_setImageWithURL(thumbnailURL, placeholderImage: placeholder)
            }
        }
        else {
            if let placeholder = UIImage(named: "placeholder") {
                movieCell.thumbnailImage.image = placeholder
            }
        }
        
        return movieCell
    }
}