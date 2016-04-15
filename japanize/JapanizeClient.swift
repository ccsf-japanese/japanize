//
//  JapanizeClient.swift
//  japanize
//
//  Created by Tom H on 4/15/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import Foundation

let serverBaseURL = NSURL(string: "https://horvathtom.com/jp/api/")

class JapanizeClient {

  class var sharedInstance: JapanizeClient {
    struct Static {
      static let instance = JapanizeClient()
    }
    
    return Static.instance
  }
}
