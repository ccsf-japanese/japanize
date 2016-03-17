//
//  ProgressViewController.swift
//  japanize
//
//  Created by Dylan Smith on 3/17/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        NSLog(">>>tableView cellForRowAtIndexPath")
        let cell = tableView.dequeueReusableCellWithIdentifier("CELLNAME", forIndexPath: indexPath) as! CELLNAME
        cell.DATA = filteredDATA[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog(">>>tableView numberOfRowsInSection")
        if filteredDATA != nil {
            return filteredDATA.count
        } else {
            return 0
        }
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
