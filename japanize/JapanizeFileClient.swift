//
//  JapanizeClient.swift
//  japanize
//
//  Created by Tom H on 4/15/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import AFNetworking

let fileServerBaseURL = NSURL(string: "https://horvathtom.com/")

class JapanizeFileClient : AFHTTPSessionManager {
  
  class var sharedInstance: JapanizeFileClient {
    struct Static {
      static let instance = JapanizeFileClient(baseURL: fileServerBaseURL)
    }
    return Static.instance
  }
  
  init(baseURL: NSURL?) {
    super.init(baseURL: baseURL, sessionConfiguration: nil)
    
    self.responseSerializer = AFHTTPResponseSerializer()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func stringForFilePath(path: String, completion: (string: String?, error: NSError?) -> ()) {
    GET(
      path,
      parameters: nil,
      progress: nil,
      success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
        completion(string: response as? String, error: nil)
      },
      failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
        print("error getting string")
        completion(string: nil, error: error)
    })
  }
  
  func dataForFilePath(path: String, completion: (data: NSData?, error: NSError?) -> ()) {
    GET(
      path,
      parameters: nil,
      progress: nil,
      success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
        completion(data: response as? NSData, error: nil)
      },
      failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
        print("error getting data")
        completion(data: nil, error: error)
    })
  }
  
}
