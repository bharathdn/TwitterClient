//
//  User.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class User: NSObject {
  var name: String?
  var screenName: String?
  var profileImageUrl: URL?
  var tagLine: String?
  var dictionary: NSDictionary?
  
  static let currentUserDataKey = "currentUserData"
  static let userDidLogoutNotification = "UserDidLogout"
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    
    name = dictionary["screen_name"] as? String
    screenName = dictionary["name"] as? String
    
    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileImageUrl = NSURL(string: profileUrlString)! as URL
    }
    
    tagLine = dictionary["description"] as? String
  }
  
  static var _currentUser: User?
  
  class var currentUser: User? {
    get{
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: currentUserDataKey) as? Data
        if let userData = userData {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options:[]) as! NSDictionary
          
          _currentUser = User(dictionary: dictionary)
        }
      }
      return _currentUser
    }
    set(user){
      _currentUser = user
      
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        
        defaults.set(data, forKey: currentUserDataKey)
      }
      else {
        defaults.removeObject(forKey: currentUserDataKey)
      }
      
      defaults.synchronize()
    }
  }
  
}
