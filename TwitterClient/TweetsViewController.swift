//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
  
  var tweets: [Tweet]!
  
  @IBOutlet weak var tableView: UITableView!
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    loadTweets()
    
    refreshControl.addTarget(self, action: #selector(TweetsViewController.loadTweets), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
  }
  
  @IBAction func onLogoutButton(_ sender: Any) {
    print("Logging out user")
    User.currentUser = nil
    TwitterClient.sharedInstance?.logout()
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
  }
  
  func loadTweets() {
    TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
      print("*** \(tweets.count) Number of tweets retrieved for user")
      
      self.tweets = tweets
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
      
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tweetDetailSegue" {
      let cell = sender as! TweetCell
      let indexPath = tableView.indexPath(for: cell)
      let tweet = tweets![indexPath!.row]
      
      let uiNavigationController = segue.destination as! UINavigationController
      let detailViewController = uiNavigationController.topViewController as! TweetDetailViewController
      detailViewController.tweet = tweet
    }
    
  }
  
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tweets != nil {
      return tweets.count
    }
    else {
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    cell.tweet = tweets[indexPath.row]
    //    print(tweets[indexPath.row])
    return cell
  }
  
}
