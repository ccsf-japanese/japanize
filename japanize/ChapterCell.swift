//
//  ChapterCell.swift
//  japanize
//
//  Created by Dylan Smith on 3/20/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

let Chapters = ["Chapter 1","Chapter 2","Chapter 3","Chapter 4","Chapter 5"]
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
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
//        return cell
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
                let level = levels[indexPath.row]
        
                if indexPath.row == 0 { //levelComplete == true {
                    //set cell text colour green (background image checkmark circle)
                    cell.levelLabel.textColor = UIColor.greenColor()
                    cell.goal1Label.textColor = UIColor.greenColor()
                    cell.goal2Label.textColor = UIColor.greenColor()
                    cell.goal3Label.textColor = UIColor.greenColor()
        
                }else if indexPath.row == 1 { //levelComplete == false {
                    //set cell text color black/system defualt (do anything?)
        //            cell.levelLabel.textColor = UIColor.blackColor()
                    cell.goal1Label.textColor = UIColor.darkGrayColor()
                    cell.goal2Label.textColor = UIColor.darkGrayColor()
                    cell.goal3Label.textColor = UIColor.darkGrayColor()
        
                    cell.levelLabel.shadowColor = UIColor.grayColor()
        
                }else{
                    // does level not touched fire this (as nil)
                    //set cell inactive and grey
                    cell.levelLabel.textColor = UIColor.grayColor()
                    cell.goal1Label.textColor = UIColor.grayColor()
                    cell.goal2Label.textColor = UIColor.grayColor()
                    cell.goal3Label.textColor = UIColor.grayColor()
                }
                
                cell.levelLabel.text = "Level"+String(level)
                return cell
    }
    
}

//extension ChapterCell : UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let itemsPerRow:CGFloat = 4
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//    
//}

