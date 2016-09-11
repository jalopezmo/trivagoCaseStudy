//
//  MovieAPI.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 11/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import Foundation

struct MovieAPI {
    
    static func buildPopularRequestURL(page:Int) -> String {
        var url = Constants.API.apiUrl.rawValue + Constants.API.movieEndpoint.rawValue
        url += Constants.API.extendedParam.rawValue + "=full,images&" + Constants.API.pageParam.rawValue + "=\(page)"
        
        return url
    }
    
    static func buildSearchRequestURL(page:Int, text:String) -> String? {
        if let escapedText = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
        
            var url = Constants.API.apiUrl.rawValue + Constants.API.searchEndpoint.rawValue
            url += Constants.API.extendedParam.rawValue + "=full,images&" + Constants.API.pageParam.rawValue + "=\(page)&" + Constants.API.queryParam.rawValue + "=\(escapedText)"
            
            return url
        }
        
        return nil
    }
    
    static func generateHeaders() -> [String:String] {
        return [Constants.Headers.apiKeyParam.rawValue:Constants.Headers.apiKeyValue.rawValue]
    }
}