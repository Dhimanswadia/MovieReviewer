//
//  DetailController.swift
//  MovieReviewer
//
//  Created by Dhiman on 1/17/16.
//  Copyright © 2016 Dhiman. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var OverviewLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TitleLabel.text = movie["title"] as! String
        OverviewLabel.text = movie["overview"] as! String
        
        let posterPath = movie["poster_path"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        imageView.setImageWithURL(imageURL!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

}
