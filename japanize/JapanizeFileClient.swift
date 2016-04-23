import UIKit
import AFNetworking

let fileServerBaseURL = NSURL(string: "https://horvathtom.com/")

class JapanizeFileClient : AFHTTPSessionManager {
  
  class var sharedInstance: JapanizeFileClient {
    struct Static {
      static let instance = JapanizeFileClient(baseURL: fileServerBaseURL)
    }
    return Static.instance
  }
  
  init(baseURL: NSURL?) {
    super.init(baseURL: baseURL, sessionConfiguration: nil)
    
    self.responseSerializer = AFHTTPResponseSerializer()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func dataForFilePath(path: String, completion: (data: NSData?, error: NSError?) -> ()) {
    GET(
      path,
      parameters: nil,
      progress: nil,
      success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
        completion(data: response as? NSData, error: nil)
      },
      failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
        print("error getting data")
        completion(data: nil, error: error)
    })
  }
  
}
