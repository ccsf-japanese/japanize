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
