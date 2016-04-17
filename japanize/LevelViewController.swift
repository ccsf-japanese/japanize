//
//  LevelViewController.swift
//  japanize
//
//  Created by Tom H on 3/15/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import ChameleonFramework

class LevelViewController: UIViewController {
  
  var level: Level?
  
    @IBOutlet weak var aLevelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      JapanizeClient.sharedInstance.characterWithID(level!.characters[0], completion: { (character, error) in
        print("received character")
        JapanizeFileClient.sharedInstance.dataForFilePath(character!.svgURL!, completion: { (data, error) in
          print("received svg")
        })
        JapanizeFileClient.sharedInstance.dataForFilePath("static/voice/bing/5b070f57a61762d2b344855987081939c7892ace.mp3", completion: { (data, error) in
          print("received mp3")
        })
        
      })
  }

    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.redColor()
        let randoColor = UIColor.randomFlatColor()
        view.backgroundColor = randoColor
        aLevelLabel.textColor = ContrastColorOf(randoColor, returnFlat: true)
        aLevelLabel.text = "CH\(level!.chapter!) \(level!.name!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
