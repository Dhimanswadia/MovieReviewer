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

    @IBOutlet weak var infoView: UIView!
    @IBOutlet var OverviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var TitleLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        TitleLabel.text = movie["title"] as! String
        OverviewLabel.text = movie["overview"] as! String
        OverviewLabel.sizeToFit()
        
        let posterPath = movie["poster_path"] as! String
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = NSURL(string: baseURL + posterPath)
        
        imageView.setImageWithURL(imageURL!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

}
