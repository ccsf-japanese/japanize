//
//  Word.swift
//  japanize
//
//  Created by Tom H on 4/16/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class Word: NSObject {
  
  var id: String?
  var kind: String?
  var chapter: String?
  var audioURL: String?
  var spellings: [String] = []
  var meanings: [String] = []
  var notes: [String] = []
  
  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? String
    kind = dictionary["kind"] as? String
    chapter = dictionary["chapter"] as? String
    audioURL = dictionary["audio_url"] as? String
    
    for spelling in (dictionary["spellings"] as? [String])! {
      spellings.append(spelling)
    }
    for meaning in (dictionary["meanings"] as? [String])! {
      meanings.append(meaning)
    }
    for note in (dictionary["notes"] as? [String])! {
      notes.append(note)
    }
  }

}
