//
//  Book.swift
//  japanize
//
//  Created by Tom H on 4/15/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class Book: NSObject {
  
  var chapters: [Chapter] = []
  
  init(dictionary: NSDictionary) {
    for chapterDict in (dictionary["chapters"] as? [NSDictionary])! {
      chapters.append(Chapter(dictionary: chapterDict))
    }
  }
  
}

