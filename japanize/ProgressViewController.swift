import UIKit
import MZFormSheetPresentationController

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var book: Book?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Show Score
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController = storyboard.instantiateViewControllerWithIdentifier("congratulationsViewController")
    let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
    formSheetController.presentationController?.contentViewSize = CGSizeMake(300, 300)
    formSheetController.presentationController?.shouldCenterVertically = true
    formSheetController.presentationController?.shouldCenterHorizontally = true
    self.presentViewController(formSheetController, animated: true, completion: nil)
    
    tableView.delegate = self
    tableView.dataSource = self
    // Do any additional setup after loading the view.
    
    JapanizeClient.sharedInstance.book( { (book, error) -> () in
      self.book = book
      self.tableView.reloadData()
    })
  }
  
  override func viewWillAppear(animated: Bool) {
    let themeColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1)
    let nav = self.navigationController?.navigationBar
    nav?.barTintColor = themeColor
    nav?.tintColor = UIColor.whiteColor()
    nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    tabBarController?.tabBar.tintColor = themeColor
  }
  
  // TODO: copy to KanjiViewController and uncomment to set theme rgb(142, 68, 173)
  // override func viewWillAppear(animated: Bool) {
  //   let themeColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1)
  //   let nav = self.navigationController?.navigationBar
  //   nav?.barTintColor = themeColor
  //   nav?.tintColor = UIColor.whiteColor()
  //   nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
  //   tabBarController?.tabBar.tintColor = themeColor
  // }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let book = self.book {
      return book.chapters.count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return book!.chapters[section].name
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChapterCell") as! ChapterCell
    cell.viewController = self
    cell.chapter = book!.chapters[indexPath.section];
    cell.selectionStyle = .None
    cell.collectionView.reloadData()
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let cell = sender as? LevelCell {
      if let vc = segue.destinationViewController as? PronunciationViewController {
        vc.level = cell.level
      } else if let vc = segue.destinationViewController as? KanjiViewController {
        vc.level = cell.level
      } else {
        assertionFailure("Destination view controller unknown")
      }
    }
  }
  
}
