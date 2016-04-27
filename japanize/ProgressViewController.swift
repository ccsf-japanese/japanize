import UIKit
import ChameleonFramework
import MZFormSheetPresentationController

class ProgressViewController: UIViewController {
  
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
    formSheetController.contentViewCornerRadius = 32.0
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
    //Theme Block
    let themeColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 1).flatten()
    let themeContrast = ContrastColorOf(themeColor, returnFlat: true)
    let nav = self.navigationController?.navigationBar
    self.navigationController?.hidesNavigationBarHairline = true
    nav?.barTintColor = themeColor
    nav?.tintColor =  themeContrast
    nav?.titleTextAttributes = [NSForegroundColorAttributeName: themeContrast]
    self.tabBarController?.tabBar.tintColor = themeColor
    //
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

extension ProgressViewController : UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ChapterCell") as! ChapterCell
    cell.viewController = self
    cell.chapter = book!.chapters[indexPath.section];
    cell.selectionStyle = .None
    cell.collectionView.reloadData()
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
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
  
}

extension ProgressViewController : UITableViewDelegate {
}
