//
//  ViewController.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 10/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    enum ServiceType : Int {
        case Popular
        case Search
    }
    
    var page:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadMoreMovies()
//        searchMovies("tron")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scrollDown() {
        loadMoreMovies()
    }
    
    func loadMoreMovies() {
        Networking.getRequest(MovieAPI.buildPopularRequestURL(page), headers: MovieAPI.generateHeaders(), completion: {
            error, responseObject in
            
            if(!error) {
                if let responseObject = responseObject as? [[String:AnyObject]] {
                    let movies = self.processResponseObject(.Popular, responseObject: responseObject)
                    
                    self.page += 1
                }
            }
        })
    }
    
    func searchMovies(text:String) {
        if let url = MovieAPI.buildSearchRequestURL(page, text: text) {
            Networking.getRequest(url, headers: MovieAPI.generateHeaders(), completion: {
                error, responseObject in
                
                if(!error) {
                    if let responseObject = responseObject as? [[String:AnyObject]] {
                        let movies = self.processResponseObject(.Search, responseObject: responseObject)
                        
                        self.page += 1
                    }
                }
            })
        }
    }
    
    func processResponseObject(type:ServiceType, responseObject:[[String:AnyObject]]) -> [Movie] {
        var movies = [Movie]()
        
        for object in responseObject {
            if(type == .Popular) {
                if let movie = Movie.initWithDictionary(object) {
                    movies.append(movie)
                }
            }
            else {
                if let innerDict = object[Constants.MovieAttributes.movie.rawValue] as? [String:AnyObject] {
                    if let movie = Movie.initWithDictionary(innerDict) {
                        movies.append(movie)
                    }
                }
            }
        }
        
        return movies
    }
}

