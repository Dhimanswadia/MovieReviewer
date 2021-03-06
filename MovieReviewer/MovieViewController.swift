//
//  MovieViewController.swift
//  MovieReviewer
//
//  Created by Dhiman on 1/10/16.
//  Copyright © 2016 Dhiman. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity


class MovieViewController: UIViewController , UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var MovieTableView: UITableView!
      var refreshControl: UIRefreshControl!
    var movies :  [NSDictionary]?
    var boxView = UIView()
     @IBOutlet var errorView: UILabel!

    @IBOutlet var config: NSObject!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        MovieTableView.insertSubview(refreshControl, atIndex: 0)
//        onRefresh()
        MovieTableView.dataSource  = self
        MovieTableView.delegate  = self
        Reload()
    }
        
    func Reload () {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        

        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.MovieTableView.reloadData()
                            self.EZloading()
                            
                    }
                }
        });
        task.resume()
        
    }
    
    func EZloading () {
        if movies == nil {
            EZLoadingActivity.hide(success: false, animated: true)
        } else {
            EZLoadingActivity.hide(success: true, animated: true)
        }
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
       movies = nil
        Reload()
        
        self.MovieTableView.reloadData()
       // EZLoadingActivity.showWithDelay("Waiting...", disableUI: false, seconds: 2)
    
        self.refreshControl.endRefreshing()
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = MovieTableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! DetailController
        movieDetailsViewController.movie = movie
        
    }
    
    
}




