//
//  ChapterCell.swift
//  japanize
//
//  Created by Dylan Smith on 3/20/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

let levels = [1,2,3,4,5]

class ChapterCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ChapterCell : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        SLog(">>>tableView numberOfRowsInSection")
        //        if levels = self.levels {
        return levels.count
        //        } else {
        //            return 0
        //        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
        let level = levels[indexPath.row]
        
        if indexPath.row == 0 { //levelComplete == true {
            //set cell text colour green
            //cell.completedImage.hidden = false
            cell.levelLabel.textColor = UIColor.greenColor()
            cell.goal1Label.textColor = UIColor.greenColor()
            cell.goal2Label.textColor = UIColor.greenColor()
            cell.goal3Label.textColor = UIColor.greenColor()
            
        }else if indexPath.row == 1 { //levelComplete == false {
            // Started, but not completed
            
        }else{
            // does level not touched fire this (as nil)
            //set cell inactive and grey
            // cell.lockedImage.hidden = false
            cell.levelLabel.textColor = UIColor.grayColor()
            cell.goal1Label.textColor = UIColor.grayColor()
            cell.goal2Label.textColor = UIColor.grayColor()
            cell.goal3Label.textColor = UIColor.grayColor()
        }
        
        cell.levelLabel.text = "Level"+String(level)
        return cell
    }
    
}


