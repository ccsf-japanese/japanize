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
  var category: String?
  var subcategory: String?
  var chapter: String?
  var audioURL: String?
  var audio: NSData?
  var romaji: String?
  var spellings: [String] = []
  var meanings: [String] = []
  var notes: [String] = []
  
  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? String
    category = dictionary["category"] as? String
    subcategory = dictionary["subcategory"] as? String
    chapter = dictionary["chapter"] as? String
    audioURL = dictionary["audio_url"] as? String
    audio = nil
    romaji = dictionary["romaji"] as? String
    
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
  
  func setAudioWithMP3(audioData: NSData) {
    audio = audioData
  }

}
