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
    let Chapters = ["Chapter 1","Chapter 2","Chapter 3","Chapter 4","Chapter 5"]
    let levels = [1,2,3,4,5]
    
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
        return Chapters.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Chapters[section]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChapterCell") as! ChapterCell
        return cell
    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
////        NSLog(">>>tableView cellForRowAtIndexPath")
//        let cell = tableView.dequeueReusableCellWithIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
//        let level = levels[indexPath.row]
//        
//        if indexPath.row == 0 { //levelComplete == true {
//            //set cell text colour green (background image checkmark circle)
//            cell.levelLabel.textColor = UIColor.greenColor()
//            cell.goal1Label.textColor = UIColor.greenColor()
//            cell.goal2Label.textColor = UIColor.greenColor()
//            cell.goal3Label.textColor = UIColor.greenColor()
//
//        }else if indexPath.row == 1 { //levelComplete == false {
//            //set cell text color black/system defualt (do anything?)
////            cell.levelLabel.textColor = UIColor.blackColor()
//            cell.goal1Label.textColor = UIColor.darkGrayColor()
//            cell.goal2Label.textColor = UIColor.darkGrayColor()
//            cell.goal3Label.textColor = UIColor.darkGrayColor()
//            
//            cell.levelLabel.shadowColor = UIColor.grayColor()
//
//        }else{
//            // does level not touched fire this (as nil)
//            //set cell inactive and grey
//            cell.levelLabel.textColor = UIColor.grayColor()
//            cell.goal1Label.textColor = UIColor.grayColor()
//            cell.goal2Label.textColor = UIColor.grayColor()
//            cell.goal3Label.textColor = UIColor.grayColor()
//        }
//        
//        cell.levelLabel.text = "Level"+String(level)
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        NSLog(">>>tableView numberOfRowsInSection")
////        if levels = self.levels {
//            return levels.count
////        } else {
////            return 0
////        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
