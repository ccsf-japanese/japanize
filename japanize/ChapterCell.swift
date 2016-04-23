import UIKit

class ChapterCell: UITableViewCell {
  
  var chapter: Chapter?
  
  @IBOutlet weak var collectionView: UICollectionView!
  
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
      if let chapter = chapter {
        return chapter.levels.count
      } else {
        return 0
      }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
        cell.level = chapter?.levels[indexPath.row]
        if indexPath.row == 0 { //levelComplete == true {
            //set cell text colour green
            //cell.completedImage.hidden = false //rgb(230, 126, 34)rgb(243, 156, 18)
            cell.backgroundColor = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
            cell.levelLabel.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
            cell.goal1Label.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
            cell.goal2Label.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
            cell.goal3Label.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
            
        } else if indexPath.row == 1 {
          
            //levelComplete == false {
            // Levels that have been started, but not completed
            // cell.backgroundColor = UIColor(red: 45/255, green: 141/255, blue: 141/255, alpha: 1)

        } else {
            // does level not touched fire this (as nil)
            //set cell inactive and grey
            // cell.lockedImage.hidden = false rgb(52, 73, 94)rgb(44, 62, 80)
            cell.backgroundColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
            cell.levelLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
            cell.goal1Label.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
            cell.goal2Label.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
            cell.goal3Label.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        }
        
        cell.levelLabel.text = cell.level!.name!
        return cell
    }
    
}


