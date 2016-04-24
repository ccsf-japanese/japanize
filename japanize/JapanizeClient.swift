import UIKit
import AFNetworking

let serverBaseURL = NSURL(string: "https://horvathtom.com/jp/api/")

class JapanizeClient : AFHTTPSessionManager {
  
  var cachedBook: Book?
  
  class var sharedInstance: JapanizeClient {
    struct Static {
      static let instance = JapanizeClient(baseURL: serverBaseURL)
    }
    return Static.instance
  }
  
  func book(completion: (book: Book?, error: NSError?) -> ()) {
    // Use cached value if available
    if let book = cachedBook {
      completion(book: book, error: nil)
    } else {
      GET(
        "book",
        parameters: nil,
        progress: nil,
        success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
          self.cachedBook = Book(dictionary: response as! NSDictionary)
          completion(book: self.cachedBook, error: nil)
        },
        failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
          print("error getting book")
          completion(book: nil, error: error)
      })
    }
  }
  
}
