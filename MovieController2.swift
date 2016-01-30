//
//  MovieController2.swift
//  MovieReviewer
//
//  Created by Dhiman on 1/20/16.
//  Copyright © 2016 Dhiman. All rights reserved.
//

import UIKit
import AFNetworking
//import EZLoadingActivity
import PKHUD






class MovieController2: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    var filteredData : [NSDictionary]?
    var endPoint : String!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var Networkerror: UIView!
    
    
    
    var movies :  [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        filteredData = movies
        Networkerror.hidden = true
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        
        let NetworkError = UITapGestureRecognizer(target: self, action: "networkError1")
        Networkerror.addGestureRecognizer(NetworkError)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        
        
        
        refreshdata()
        
        
        
    }
    
    
    @IBAction func dismisskeyboard(sender: AnyObject) {
        self.searchBar.resignFirstResponder()
    }
    
    
    
    func refreshdata() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
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
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredData = self.movies
                            self.Networkerror.hidden = true
                            self.collectionView.reloadData();
                            
                            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                            PKHUD.sharedHUD.show()
                            PKHUD.sharedHUD.hide(afterDelay: 2.0)
                            
                            
                    }
                } else {
                    self.Networkerror.hidden = false
                    
                    
                }
                if error != nil {
                    self.Networkerror.hidden = false
                    
                }
                
        });
        task.resume()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
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
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        refreshdata()
        delay(0.2) { () -> () in
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0)
            self.refreshControl.endRefreshing()
        }
    }
    func networkError1() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        delay(2, closure: {
            PKHUD.sharedHUD.contentView = PKHUDErrorView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 2.0);
        })
        refreshdata()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredData = filteredData{
            return filteredData.count
        } else {
            return 0
        }
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell2", forIndexPath: indexPath) as! MovieCell2
        
        let movie = filteredData?[indexPath.row]
            let title = movie!["title"] as? String
                let baseUrl = "http://image.tmdb.org/t/p/w500"
                if let  posterPath = movie!["poster_path"] as? String {
                let imageUrl = NSURL(string: baseUrl + posterPath)
               // cell.movieView.alpha = 0
               // cell.movieView.setImageWithURL(imageUrl!)
                cell.movieView.setImageWithURLRequest(
                    NSURLRequest(URL: imageUrl!),
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        
                        if imageResponse != nil {
                            print("fade om Image")
                            cell.movieView.alpha = 0.0
                            cell.movieView.image = image
                            UIView.animateWithDuration(1.1, animations: { () -> Void in
                                cell.movieView.alpha = 1.0
                            })
                        } else {
                            print("Image was cached ")
                            cell.movieView.image = image
                            UIView.animateWithDuration(1.1, animations: { () -> Void in
                                cell.movieView.alpha = 1.0
                            })

                        
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        cell.movieView.image = UIImage(named: "pic")
                })
                
        }
        let selbackgroundView = UIView()
        selbackgroundView.backgroundColor = UIColor.greenColor()
        cell.selectedBackgroundView = selbackgroundView
        
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPathForCell(cell)!
        
        let movie = filteredData![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! DetailController
        movieDetailsViewController.movie = movie
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("search")
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movieName: NSDictionary) -> Bool in
            if let title = movieName["title"] as? String {
                return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
            return false
        })
        
        collectionView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        self.filteredData = movies
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    
}
