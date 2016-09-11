//
//  Networking.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 11/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import UIKit
import Alamofire

class Networking: NSObject {

    static func getRequest(url:String, headers:[String:String]? = nil, completion:(error:Bool, object:[AnyObject]?)->Void) {
        
        Alamofire.request(.GET, url, headers:headers).responseJSON {
            response in
            
            if let json = response.result.value as? [AnyObject]{
                completion(error: false, object: json)
            }
            else {
                completion(error: true, object: nil)
            }
        }
    }
    
}
