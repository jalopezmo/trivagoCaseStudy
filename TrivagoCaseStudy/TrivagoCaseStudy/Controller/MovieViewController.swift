//
//  ViewController.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 10/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import UIKit
import PKHUD

class MovieViewController: UIViewController, UITableViewDelegate {
    
    enum ServiceType : Int {
        case Popular
        case Search
    }
    
    var page:Int = 1
    var dataSource = MovieTableViewDataSource()
    var debounce = false
    
    @IBOutlet weak var movieTableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.rowHeight = UITableViewAutomaticDimension
        movieTableView.dataSource = dataSource
        movieTableView.delegate = self
        
        loadMoreMovies()
    }

    func scrollDown() {
        loadMoreMovies()
    }
    
    func loadMoreMovies() {
        HUD.show(.Progress)
        
        Networking.getRequest(MovieAPI.buildPopularRequestURL(page), headers: MovieAPI.generateHeaders(), completion: {
            error, responseObject in
            
            HUD.hide()
            
            if(!error) {
                if let responseObject = responseObject as? [[String:AnyObject]] {
                    self.dataSource.movies.appendContentsOf(self.processResponseObject(.Popular, responseObject: responseObject))
                    self.page += 1
                    self.movieTableView.reloadData()
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
    
    //Search view activated
    @IBAction func searchButtonTapped() {
        print("Search")
    }
    
    //TableView delegate
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //handle open trailer here (in case there is one)
        
        if let trailerURL = dataSource.getTrailerUrlForMovie(indexPath.row) {
            UIApplication.sharedApplication().openURL(NSURL(string: trailerURL)!)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if(!debounce) {
                debounce = true
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), {
                    sleep(2)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.debounce = false
                    })
                })
                
                loadMoreMovies()
            }
        }
    }
}

