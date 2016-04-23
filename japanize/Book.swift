import UIKit

class Book: NSObject {
  
  var chapters: [Chapter] = []
  
  init(dictionary: NSDictionary) {
    for chapterDict in (dictionary["chapters"] as? [NSDictionary])! {
      chapters.append(Chapter(dictionary: chapterDict))
    }
  }
  
}
