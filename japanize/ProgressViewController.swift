//
//  ProgressViewController.swift
//  japanize
//
//  Created by Dylan Smith on 3/17/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //    var levels: [Level]?
    let chapters = ["Chapter 1","Chapter 2","Chapter 3","Chapter 4","Chapter 5"]
    //    let levels = [1,2,3,4,5]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: 18/255, green: 165/255, blue: 244/255, alpha: 0)
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return chapters.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return chapters[section]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChapterCell") as! ChapterCell
        return cell
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        let cell = sender as! UITableViewCell
    //        let indexpath = tableView.indexPathForCell(cell)
    //        let chapter = chapters[indexpath!.row]
    //
    //        tableView.deselectRowAtIndexPath(indexpath!, animated: true)
    //
    //        let detailViewController = segue. as! ChapterCell
    //        detailViewController.chapter = chapter
    //    
    //        print("Segue")
    //    }
    
}
