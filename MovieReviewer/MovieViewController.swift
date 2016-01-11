//
//  MovieViewController.swift
//  MovieReviewer
//
//  Created by Dhiman on 1/10/16.
//  Copyright © 2016 Dhiman. All rights reserved.
//

import UIKit
import AFNetworking

class MovieViewController: UIViewController , UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var MovieTableView: UITableView!
    var movies :  [NSDictionary]?

    
    override func viewDidLoad() {
           super.viewDidLoad()
        MovieTableView.dataSource  = self
        MovieTableView.delegate  = self
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.MovieTableView.reloadData()
                            
                            
                    }
                }
        });
        task.resume()
        }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
        return 0
        }
}

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MovieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
    let movie = movies![indexPath.row]
        let title = movie["title"] as!String
        let overview = movie["overview"] as!String
        let posterPath = movie["poster_path"] as!String
        
        let BaseURL = "http://image.tmdb.org/t/p/w500"
        
        let ImageURL = NSURL(string: BaseURL + posterPath)
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.POSTERvIEW.setImageWithURL(ImageURL! )
        
        print("row \( indexPath.row)")
        return cell
    }



}