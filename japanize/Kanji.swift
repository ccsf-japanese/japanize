//
//  Kanji.swift
//  japanize
//
//  Created by Xinxin Xie on 4/3/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class Kanji {
    
    let strokes: [Stroke]
    
    init() {
      var pathStrings: [String] = []
      let path = NSBundle.mainBundle().pathForResource("054a8", ofType: "svg")!
      let content: NSString = try! String(contentsOfFile: path)
      let regex = try! NSRegularExpression(pattern: " d=\"(.*)\"", options: [])
      
      let matches = regex.matchesInString(content as String, options: [], range: NSRange(location: 0, length: content.length))
      for match in matches {
        let range = match.rangeAtIndex(1)
        pathStrings.append(content.substringWithRange(range))
      }
      
      var strokes: [Stroke] = []
        for pathString in pathStrings {
            strokes.append(Stroke(pathString: pathString))
      }
      self.strokes = strokes
    }
}