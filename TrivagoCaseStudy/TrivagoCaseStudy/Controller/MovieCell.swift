//
//  Movie Cell.swift
//  TrivagoCaseStudy
//
//  Created by Jaime Andres Lopez Mora on 11/09/16.
//  Copyright © 2016 jaimelopez. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var taglineLabel : UILabel!
    @IBOutlet weak var releaseDateLabel : UILabel!
    @IBOutlet weak var overviewLabel : UILabel!
    @IBOutlet weak var runtimeLabel : UILabel!
    @IBOutlet weak var genreLabel : UILabel!
    @IBOutlet weak var thumbnailImage : UIImageView!
    @IBOutlet weak var ratingLabel : UILabel!
    
    var movie:Movie?
    
    
}
