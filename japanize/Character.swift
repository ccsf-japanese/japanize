//
//  Character.swift
//  japanize
//
//  Created by Tom H on 4/15/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class Character: NSObject {
  
  var id: String?
  var value: String?
  var kind: String?
  var chapter: String?
  var svgURL: String?
  
  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? String
    value = dictionary["value"] as? String
    kind = dictionary["kind"] as? String
    chapter = dictionary["chapter"] as? String
    svgURL = dictionary["svg_url"] as? String
  }
  
}
