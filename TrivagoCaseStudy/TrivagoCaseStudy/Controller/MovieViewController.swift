//
//  ViewController.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 10/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import UIKit
import PKHUD

class MovieViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    enum ServiceType : Int {
        case Popular
        case Search
    }
    
    var page:Int = 1
    var dataSource = MovieTableViewDataSource()
    var debounce = false
    var serviceType:ServiceType = .Popular
    var lastSearchedString = ""
    var noMoreAvailable = false
    
    @IBOutlet weak var movieTableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.rowHeight = UITableViewAutomaticDimension
        movieTableView.dataSource = dataSource
        movieTableView.delegate = self
        
        loadMoreMovies()
    }
    
    func loadMoreMovies() {
        
        if(noMoreAvailable) {
            return
        }
        
        var url:String?
        
        if(serviceType == .Popular) {
            url = MovieAPI.buildPopularRequestURL(page)
        }
        else {
            url = MovieAPI.buildSearchRequestURL(page, text: lastSearchedString)
        }
        
        if let requestURL = url {
            HUD.show(.Progress)
            
            Networking.getRequest(requestURL, headers: MovieAPI.generateHeaders(), completion: {
                error, responseObject in
                
                HUD.hide()
                
                if(!error) {
                    if let responseObject = responseObject as? [[String:AnyObject]] {
                        self.dataSource.movies.appendContentsOf(self.processResponseObject(self.serviceType, responseObject: responseObject))
                        self.page += 1
                        self.movieTableView.reloadData()
                        
                        if(responseObject.count < 10) {
                            self.noMoreAvailable = true
                        }
                        else {
                            self.noMoreAvailable = false
                        }
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
    
    @IBAction func searchButtonClicked() {
        self.searchBar.becomeFirstResponder()
    }
    
    //TableView delegate
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //handle open trailer here (in case there is one)
        
        if let trailerURL = dataSource.getTrailerUrlForMovie(indexPath.row) {
            if let validURL = NSURL(string: trailerURL) {
                UIApplication.sharedApplication().openURL(validURL)
                return
            }
        }
        
        let alertViewController = UIAlertController(title: "We're sorry!", message: "There is no trailer for this movie :(", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { _ in }
        
        alertViewController.addAction(okAction)
        presentViewController(alertViewController, animated: true, completion: nil)
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
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    //Search bar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Check if search string is empty
        if(searchText.isEmpty || searchText == " ") {
            searchBar.text = ""
            serviceType = .Popular
            
            if(lastSearchedString != "") {
                resetMovieList()
            }
            
            lastSearchedString = ""
            return
        }
        
        serviceType = .Search
        lastSearchedString = searchText
        resetMovieList()
    }
    
    func resetMovieList() {
        Networking.cancelAllRequests()
        movieTableView.setContentOffset(CGPointZero, animated: false);
        noMoreAvailable = false
        dataSource.clearDataSourceArray()
        page = 1
        movieTableView.reloadData()
        loadMoreMovies()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

