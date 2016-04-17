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
  var strokes: [Stroke]?
  
  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? String
    value = dictionary["value"] as? String
    kind = dictionary["kind"] as? String
    chapter = dictionary["chapter"] as? String
    svgURL = dictionary["svg_url"] as? String
    strokes = nil
  }
  
  func setStrokesWithSVG(data: NSData) {
    let content = NSString.init(data: data, encoding: NSUTF8StringEncoding)!
    let regex = try! NSRegularExpression(pattern: " d=\"(.*)\"", options: [])
    var pathStrings: [String] = []
    
    let matches = regex.matchesInString(content as String,
                                        options: [],
                                        range: NSRange(location: 0, length: content.length))
    for match in matches {
      let range = match.rangeAtIndex(1)
      pathStrings.append(content.substringWithRange(range))
    }
    
    self.strokes = []
    for pathString in pathStrings {
      self.strokes!.append(Stroke(pathString: pathString))
    }
  }
  
}
