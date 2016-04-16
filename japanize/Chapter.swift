//
//  Chapter.swift
//  japanize
//
//  Created by Dylan Smith on 3/23/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class Chapter: NSObject {
  
  var id: String!
  var name: String!
  var levels: [Level] = []

  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? String
    name = dictionary["name"] as? String
    
    for levelDict in (dictionary["levels"] as? [NSDictionary])! {
      levels.append(Level(dictionary: levelDict))
    }
  }
  
}

/*var kanji: NSDictionary?
 [difficulty: chaper.level
 audio: bool
 audioURL: URL
 japanese: String?
 english: String?]
 
 var words: NSDictionary?
 [audio: BOOL
 audioURL: URL
 kanji: String
 hiragana: String
 katakana: String
 romaji: String?
 english: String?]*/