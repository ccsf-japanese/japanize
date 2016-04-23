import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var wordDay: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var todaysWordInfo: [String]?
    var tapCount: Int = 0
    
//    TODO: get word id (for info label)
    let todaysWord = "日本語"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordDay.text = "Learn the word \(todaysWord)"
        infoLabel.hidden = true
        todaysWordInfo = ["にほんご","Nihongo","Japanese (Language)",""]

        
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPractice(sender: AnyObject) {
        let url =  NSURL(string:"japanize://")
        self.extensionContext?.openURL(url!, completionHandler: nil)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        if todaysWordInfo != nil {
            infoLabel.hidden = false
            infoLabel.text = todaysWordInfo![tapCount]
            tapCount += 1
            if tapCount == todaysWordInfo!.count{
                tapCount = 0
                infoLabel.hidden = true
            }
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
