import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"

class User: NSObject {
  
  var score: Int = 0
  var levelsComplete: NSMutableDictionary = [:]
  
  init(dictionary: NSDictionary) {
    score = dictionary["score"] as! Int
    if let levelsComplete = dictionary["levels_complete"] as? NSMutableDictionary {
      self.levelsComplete = levelsComplete
    }
  }
  
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
          do {
            let dictionary =
              try NSJSONSerialization.JSONObjectWithData(data!,
                                                         options: NSJSONReadingOptions(rawValue:0)) as! NSDictionary
            _currentUser = User(dictionary: dictionary)
          }
          catch {
            print("Error parsing JSON")
          }
        } else {
          _currentUser = User(dictionary: ["score" : 0, "levels_complete" : [:]])
        }
      }
      return _currentUser
    }
    
    set(user) {
      _currentUser = user
      
      if _currentUser != nil {
        do {
          let dict = ["score" : _currentUser!.score, "levels_complete" : _currentUser!.levelsComplete]
          let data =
            try NSJSONSerialization.dataWithJSONObject(dict,
                                                       options: NSJSONWritingOptions(rawValue:0))
          NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
        }
        catch {
          print("Error parsing JSON")
          NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
        }
      } else {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
      }
      
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
}
